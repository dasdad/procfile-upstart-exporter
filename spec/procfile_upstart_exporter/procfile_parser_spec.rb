require 'spec_helper'

describe ProcfileUpstartExporter::ProcfileParser do
  subject(:procfile_parser) { ProcfileUpstartExporter::ProcfileParser.new }

  describe '#parse' do
    subject(:processes) { procfile_parser.parse procfile }

    let(:procfile) { 'spec/fixtures/sample-application/Procfile' }

    it 'reads Procfile' do
      expect(File).to receive(:read).with(procfile).and_return('')
      subject
    end

    it 'returns Processes for each line' do
      expect(processes).to eq([
        ProcfileUpstartExporter::Process.with(
          name: 'web',
          command: 'bundle exec rails server -p 5000'
        ),
        ProcfileUpstartExporter::Process.with(
          name: 'background',
          command: 'bundle exec sidekiq'
        )
      ])
    end
  end
end
