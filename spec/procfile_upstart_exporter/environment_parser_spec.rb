require 'spec_helper'

describe ProcfileUpstartExporter::EnvironmentParser do
  subject(:environment_parser) {
    ProcfileUpstartExporter::EnvironmentParser.new
  }

  describe '#parse' do
    subject(:environment_variables) { environment_parser.parse environment }

    let(:environment) { 'spec/fixtures/sample-application/.env' }

    it 'reads the environment file' do
      expect(File).to receive(:read).with(environment).and_call_original
      subject
    end

    it 'returns an Array of Strings with environment variables' do
      expect(environment_variables).to eq(
        %w{ RAILS_ENV=production DATABASE_URL=postgresl://localhost:4567 }
      )
    end

    context 'environment file does not exist' do
      let(:environment) { 'non-existing-file' }

      it 'returns an empty Array' do
        expect(environment_variables).to eq([])
      end
    end
  end
end
