class ProcfileUpstartExporter::Creator
  def initialize procfile_parser = ProcfileUpstartExporter::ProcfileParser.new
    self.procfile_parser = procfile_parser
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
        'banana')
    end
  end

  private

  attr_accessor :procfile_parser
end
