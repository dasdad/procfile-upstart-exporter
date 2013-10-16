class ProcfileUpstartExporter::ProcfileParser
  def parse procfile
    ProcfileUpstartExporter.logger.debug 'Start parsing Procfile ' \
                                         "`#{ procfile }'"
    File.read(procfile).split("\n").map do |process_line|
      ProcfileUpstartExporter::Process.new(
        *process_line.scan(/\A([^:]+):(.*)\z/).first.map(&:strip)
      )
    end
  end
end
