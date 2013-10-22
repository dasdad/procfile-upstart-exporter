require 'spec_helper'

describe ProcfileUpstartExporter::Creator do
  subject(:creator) {
    ProcfileUpstartExporter::Creator.new procfile_parser, environment_parser,
                                         process_job_renderer
  }

  let(:procfile_parser)      { double }
  let(:environment_parser)   { double }
  let(:process_job_renderer) { double }

  describe '#create' do
    subject(:create) {
      Dir.chdir 'spec/fixtures/sample-application' do
        creator.create application, procfile, log, environment, user,
                                                              upstart_jobs_path
      end
    }

    let(:application)       { 'application'              }
    let(:procfile)          { 'Procfile'                 }
    let(:log)               { "#{ temp_dir }/log"        }
    let(:application_log)   { "#{ log }/#{ application}" }
    let(:environment)       { 'environment'              }
    let(:user)              { 'bin'                      }
    let(:upstart_jobs_path) { temp_dir                   }
    let(:application_root)  {
      File.expand_path 'spec/fixtures/sample-application'
    }
    let(:environment_variables) {
      %w{ RAILS_ENV=production DATABASE_URL=postgresl://localhost:4567 }
    }
    let(:web_process) {
      ProcfileUpstartExporter::Process.with(
        name: 'web',
        command: 'bundle exec rails server -p 5000'
      )
    }
    let(:background_process) {
      ProcfileUpstartExporter::Process.with(
        name: 'background',
        command: 'bundle exec sidekiq'
      )
    }

    before do
      allow(procfile_parser).to receive(:parse)
        .and_return [web_process, background_process]

      allow(environment_parser).to receive(:parse)
                                   .and_return environment_variables

      allow(process_job_renderer).to receive(:render)
        .with(application, user, environment_variables, application_root,
              log, web_process)
        .and_return <<-JOB_CONFIGURATION
env RAILS_ENV=production
env DATABASE_URL=postgresl://localhost:4567
exec bundle exec rails server -p 5000
JOB_CONFIGURATION

      allow(process_job_renderer).to receive(:render)
        .with(application, user, environment_variables, application_root,
              log, background_process)
        .and_return <<-JOB_CONFIGURATION
env RAILS_ENV=production
env DATABASE_URL=postgresl://localhost:4567
exec bundle exec sidekiq
JOB_CONFIGURATION

      allow(FileUtils).to receive(:chown)
    end

    it 'creates an Upstart job for the application' do
      create
      expect(
        File.exists? "#{ upstart_jobs_path }/#{ application }.conf"
      ).to be_true
    end

    it 'renders the Upstart job template for each process in Procfile' do
      create
      expect(
        File.read "#{ upstart_jobs_path }/#{ application }/web.conf"
      ).to match 'bundle exec rails server -p 5000'
      expect(
        File.read "#{ upstart_jobs_path }/#{ application }/background.conf"
      ).to match 'bundle exec sidekiq'
    end

    it 'creates a folder for logging owned by the user' do
      expect(FileUtils).to receive(:chown).with(user, user, application_log)
      create
      expect(File.directory? application_log).to be_true
    end

    it "places environment variables from environment file in Upstart job" do
      create
      expect(
        File.read("#{ upstart_jobs_path }/#{ application }/background.conf")
      ).to match 'RAILS_ENV=production'
    end
  end
end
