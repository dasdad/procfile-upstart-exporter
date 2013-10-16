require 'spec_helper'

describe ProcfileUpstartExporter::Creator do
  subject(:creator) { ProcfileUpstartExporter::Creator.new }

  let(:application)       { 'application' }
  let(:procfile)          { 'Procfile'    }
  let(:log)               { '/var/log'    }
  let(:environment)       { '.env'        }
  let(:user)              { 'app'         }
  let(:upstart_jobs_path) { temp_dir      }

  describe '#create' do
    before do
      creator.create application, procfile, log, environment, user,
                                                            upstart_jobs_path
    end

    it 'creates an Upstart job for the application' do
      expect(
        File.exists? "#{ upstart_jobs_path }/#{ application }.conf"
      ).to be_true
    end

    it 'creates an Upstart job for each process in Procfile'
    it 'creates a folder for logging owned by the user'
    it "places environment variables from `.env' in process' Upstart job"
  end
end
