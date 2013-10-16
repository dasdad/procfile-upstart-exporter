class ProcfileUpstartExporter::Creator
  def create(application, procfile, log, environment, user, upstart_jobs_path,
             templates_path = File.expand_path('../../../templates', __FILE__))
    FileUtils.cp File.join(templates_path, 'application.conf'),
      File.join(upstart_jobs_path, "#{ application }.conf")
  end
end
