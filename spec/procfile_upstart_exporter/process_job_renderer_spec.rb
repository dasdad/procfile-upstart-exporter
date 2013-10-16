require 'spec_helper'

describe ProcfileUpstartExporter::ProcessJobRenderer do
  subject(:process_job_renderer) {
    ProcfileUpstartExporter::ProcessJobRenderer.new
  }

  describe '#render' do
    subject(:process_job) {
      process_job_renderer.render application, user, environment_variables,
                                  application_root, log, process
    }

    let(:application)       { 'application'                      }
    let(:user)              { 'bin'                              }
    let(:log)               { "#{ temp_dir }/log"                }
    let(:application_root)  {
      File.expand_path 'spec/fixtures/sample-application'
    }
    let(:environment_variables) {
      %w{ RAILS_ENV=production DATABASE_URL=postgresl://localhost:4567 }
    }
    let(:process) {
      ProcfileUpstartExporter::Process.with(
        name: 'web',
        command: 'bundle exec rails server -p 5000'
      )
    }

    it 'renders the template' do
      expect(process_job).to eq(<<-PROCESS_JOB)
start on starting application
stop  on stopping application

respawn

setuid bin
setgid bin

env HOME=/bin
env RAILS_ENV=production
env DATABASE_URL=postgresl://localhost:4567

chdir #{ application_root }

exec bash -lc 'bundle exec rails server -p 5000 >> #{ log }/application/web.log 2>&1'
PROCESS_JOB
    end
  end
end
