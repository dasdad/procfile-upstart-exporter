class ProcfileUpstartExporter::EnvironmentParser
  def parse environment
    File.read(environment).split("\n")
  end
end
