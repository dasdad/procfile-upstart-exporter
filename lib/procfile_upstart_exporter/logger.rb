module ProcfileUpstartExporter
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new(STDOUT).tap do |logger|
        logger.level = defined?(RSpec) ? Logger::FATAL : Logger::INFO
      end
    end
  end
end
