class ProcfileUpstartExporter::EnvironmentParser
  def parse environment
    ProcfileUpstartExporter.logger.debug "Start parsing environment file " \
                                         "`#{ environment }'"
    if File.exists? environment
      File.read(environment).split("\n").reject { |line|
        line =~ /\A\s*(?:#.*)?\z/
      }
    else
      ProcfileUpstartExporter.logger.warn "Environment file " \
                                          "`#{ environment }' does not exist"
      []
    end
  end
end
