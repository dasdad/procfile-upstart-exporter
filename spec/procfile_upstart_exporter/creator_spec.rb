require 'spec_helper'

describe ProcfileUpstartExporter::Creator do
  subject(:creator) { ProcfileUpstartExporter::Creator.new procfile_parser }

  let(:procfile_parser) { double parse: processes }
  let(:processes)       {
    [
      ProcfileUpstartExporter::Process.with(
        name: 'web',
        command: 'bundle exec rails server -p 5000'),
      ProcfileUpstartExporter::Process.with(
        name: 'background',
        command: 'bundle exec sidekiq'),
    ]
  }

  describe '#create' do
    let(:application)       { 'application'       }
    let(:procfile)          { 'Procfile'          }
    let(:log)               { "#{ temp_dir }/log" }
    let(:environment)       { '.env'              }
    let(:user)              { 'bin'               }
    let(:upstart_jobs_path) { temp_dir            }

    def act
      allow(FileUtils).to receive(:chown)
      Dir.chdir 'spec/fixtures/sample-application' do
        creator.create application, procfile, log, environment, user,
                                                              upstart_jobs_path
      end
    end

    it 'creates an Upstart job for the application' do
      act
      expect(
        File.exists? "#{ upstart_jobs_path }/#{ application }.conf"
      ).to be_true
    end

    it 'creates an Upstart job for each process in Procfile' do
      act
      expect(
        File.exists? "#{ upstart_jobs_path }/#{ application }/web.conf"
      ).to be_true
      expect(
        File.exists? "#{ upstart_jobs_path }/#{ application }/background.conf"
      ).to be_true
    end

    it 'creates a folder for logging owned by the user' do
      expect(FileUtils).to receive(:chown).with(user, user, log)
      act
      expect(File.directory? log).to be_true
    end

    it "places environment variables from `.env' in process' Upstart job"
  end
end
