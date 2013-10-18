class ProcfileUpstartExporter::EnvironmentParser
  def parse environment
    ProcfileUpstartExporter.logger.debug "Start parsing environment file " \
                                         "`#{ environment }'"
    if File.exists? environment
      File.read(environment).split("\n")
    else
      ProcfileUpstartExporter.logger.warn "Environment file " \
                                          "`#{ environment }' does not exist"
      []
    end
  end
end
