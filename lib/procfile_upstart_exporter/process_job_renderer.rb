class ProcfileUpstartExporter::ProcessJobRenderer
  attr_reader :template

  def initialize(
    template = File.expand_path(
      File.join('..', '..', '..', 'templates', 'process.conf.erb'))
  )
    @template = template
  end

  def render application, user, environment_variables, application_root,
             log, process
    # Double assign to avoid warnings
    home = home = Etc.getpwnam(user).dir
    fail NotImplementedError
  end
end
