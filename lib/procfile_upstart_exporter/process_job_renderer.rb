class ProcfileUpstartExporter::ProcessJobRenderer
  attr_reader :template

  def initialize(
    template = File.read(
      File.expand_path(
        File.join('..', '..', '..', 'templates', 'process.conf.erb'), __FILE__
      )
    )
  )
    @erb = ERB.new template, nil, '-'
  end

  def render application, user, environment_variables, application_root,
             log, process
    ProcfileUpstartExporter.logger.debug 'Start rendering process job'
    # Double assign to avoid warnings
    home = home = Etc.getpwnam(user).dir
    @erb.result binding
  end
end
