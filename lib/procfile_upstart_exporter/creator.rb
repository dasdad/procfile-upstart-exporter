class ProcfileUpstartExporter::Creator
  def initialize(
    procfile_parser      = ProcfileUpstartExporter::ProcfileParser.new,
    environment_parser   = ProcfileUpstartExporter::EnvironmentParser.new,
    process_job_renderer = ProcfileUpstartExporter::ProcessJobRenderer.new
  )
    self.procfile_parser      = procfile_parser
    self.environment_parser   = environment_parser
    self.process_job_renderer = process_job_renderer
  end

  def create(
    application, procfile, log, environment, user, group, upstart_jobs_path,
    templates_path = File.expand_path('../../../templates', __FILE__)
  )
    ProcfileUpstartExporter.logger.debug 'Starting Upstart jobs creation ' \
                                         "for `#{ application }'"
    application_template = File.join templates_path, 'application.conf'
    application_job      = File.join upstart_jobs_path, "#{ application }.conf"
    application_path     = File.join upstart_jobs_path, application
    application_log_path = File.join log, application

    # --no-group -> nil
    # --group "foo" -> "foo"
    # default: false -> user
    group = user if group == false

    FileUtils.cp application_template, application_job
    FileUtils.mkdir_p application_path
    FileUtils.mkdir_p application_log_path
    FileUtils.chown user, group, application_log_path
    procfile_parser.parse(procfile).each do |process|
      File.write(
        File.join(application_path, "#{ process.name }.conf"),
        process_job_renderer.render(
          application, user, group, environment_parser.parse(environment),
          Dir.pwd, log, process
        )
      )
    end
    ProcfileUpstartExporter.logger.debug 'Created Upstart jobs for ' \
                                         "`#{ application }'"
  end

  private

  attr_accessor :procfile_parser
  attr_accessor :environment_parser
  attr_accessor :process_job_renderer
end
