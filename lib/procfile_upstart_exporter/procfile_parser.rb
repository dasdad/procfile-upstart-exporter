class ProcfileUpstartExporter::ProcfileParser
  def parse procfile
    ProcfileUpstartExporter.logger.debug 'Start parsing Procfile ' \
                                         "`#{ procfile }'"
    if File.exists? procfile
      processes = File.read(procfile).split("\n").map(&:strip).reject(&:empty?)
      processes.map do |process_line|
        ProcfileUpstartExporter::Process.new(
          *process_line.scan(/\A([^:]+):(.*)\z/).first.map(&:strip)
        )
      end
    else
      ProcfileUpstartExporter.logger.warn "Procfile file " \
                                          "`#{ procfile }' does not exist"
      []
    end
  end
end
