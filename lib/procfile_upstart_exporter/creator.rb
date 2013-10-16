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

  def create(application, procfile, log, environment, user, upstart_jobs_path,
             templates_path = File.expand_path('../../../templates', __FILE__))
    application_template = File.join templates_path, 'application.conf'
    application_job      = File.join upstart_jobs_path, "#{ application }.conf"
    application_path     = File.join upstart_jobs_path, application

    FileUtils.cp application_template, application_job
    FileUtils.mkdir application_path
    FileUtils.mkdir log
    FileUtils.chown user, user, log
    procfile_parser.parse(procfile).each do |process|
      File.write(
        File.join(application_path, "#{ process.name }.conf"),
        process_job_renderer.render(
          application, user, environment_parser.parse(environment),
          Dir.pwd, log, process
        )
      )
    end
  end

  private

  attr_accessor :procfile_parser
  attr_accessor :environment_parser
  attr_accessor :process_job_renderer
end
