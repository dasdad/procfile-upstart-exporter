require 'spec_helper'

describe ProcfileUpstartExporter::Destroyer do
  subject(:destroyer) { ProcfileUpstartExporter::Destroyer.new }

  describe '#destroy' do
    let(:application) { 'application' }
    let(:path)        { temp_dir      }

    let(:act) {
      destroyer.destroy application, path
    }

    before do
      FileUtils.mkdir_p "#{ path }/#{ application }"
      FileUtils.touch   "#{ path }/#{ application }.conf"
      FileUtils.touch   "#{ path }/#{ application }/web.conf"
      allow(Kernel).to receive(:system)
    end

    it 'stops the jobs' do
      expect(Kernel).to receive(:system).with 'stop', application
      act
    end

    it 'deletes Upstart jobs'
  end
end
