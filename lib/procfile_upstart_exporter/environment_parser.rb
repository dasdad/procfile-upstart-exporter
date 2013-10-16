class ProcfileUpstartExporter::EnvironmentParser
  def parse environment
    ProcfileUpstartExporter.logger.debug "Start parsing environment file " \
                                         "`#{ environment }'"
    File.read(environment).split("\n")
  end
end
