require 'spec_helper'

describe ProcfileUpstartExporter::Destroyer do
  subject(:destroyer) { ProcfileUpstartExporter::Destroyer.new }

  describe '#destroy' do
    let(:application) { 'application' }
    let(:path)        { temp_dir      }
    let(:application_path) { "#{ path }/#{ application }" }
    let(:application_job)  { "#{ path }/#{ application }.conf" }
    let(:process_job)      { "#{ path }/#{ application }/web.conf" }

    let(:act) {
      destroyer.destroy application, path
    }

    before do
      FileUtils.mkdir_p application_path
      FileUtils.touch   application_job
      FileUtils.touch   process_job
      allow(Kernel).to receive(:system)
    end

    it 'stops the jobs' do
      expect(Kernel).to receive(:system).with 'stop', application
      act
    end

    it 'deletes Upstart jobs' do
      act
      [application_path, application_job, process_job].each do |path|
        expect(File.exists? path).to be_false
      end
    end
  end
end
