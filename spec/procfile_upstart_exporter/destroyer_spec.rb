require 'spec_helper'

describe ProcfileUpstartExporter::Destroyer do
  subject(:destroyer) {
    ProcfileUpstartExporter::Destroyer.new procfile_parser
  }

  let(:procfile_parser) { double }

  describe '#destroy' do
    subject(:destroy) {
      destroyer.destroy application, path, procfile
    }

    let(:application)      { 'application'                                }
    let(:path)             { temp_dir                                     }
    let(:procfile)         { nil                                          }
    let(:application_path) { "#{ path }/#{ application }"                 }
    let(:application_job)  { "#{ path }/#{ application }.conf"            }
    let(:web_job)          { "#{ path }/#{ application }/web.conf"        }
    let(:background_job)   { "#{ path }/#{ application }/background.conf" }

    before do
      FileUtils.mkdir_p application_path
      FileUtils.touch   application_job
      FileUtils.touch   web_job
      FileUtils.touch   background_job
      allow(IO).to receive(:popen).and_call_original
    end

    it 'stops the jobs' do
      expect(IO).to receive(:popen).with(['stop', application],
                                         err: [:child, :out]).and_call_original
      destroy
    end

    it 'deletes Upstart jobs' do
      destroy
      [
        application_path,
        application_job,
        web_job,
        background_job
      ].each do |path|
        expect(File.exists? path).to be_false
      end
    end

    context 'a Procfile is given' do
      let(:procfile) { 'Procfile' }
      let(:web_process) {
        ProcfileUpstartExporter::Process.with(
          name: 'web',
          command: 'bundle exec rails server -p 5000'
        )
      }

      before do
        allow(procfile_parser).to receive(:parse)
                                  .with(procfile)
                                  .and_return([web_process])
      end

      it 'only stops the processes not present in the Procfile' do
        expect(IO).to receive(:popen)
                      .with(['stop', "#{ application }/background"],
                                         err: [:child, :out]).and_call_original
        destroy
      end

      it 'only deletes the jobs not present in the Procfile' do
        destroy
        expect(File.exists? background_job).to be_false
        [
          application_path,
          application_job,
          web_job
        ].each do |path|
          expect(File.exists? path).to be_true
        end
      end
    end
  end
end
