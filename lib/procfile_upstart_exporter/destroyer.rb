class ProcfileUpstartExporter::Destroyer
  def destroy application, path
    ProcfileUpstartExporter.logger.debug 'Starting Upstart jobs deletion'
    Kernel.system 'stop', application
    FileUtils.rm_rf File.join(path, "#{ application }.conf")
    FileUtils.rm_rf File.join(path, application)
    ProcfileUpstartExporter.logger.info 'Deleted Upstart jobs for' \
                                        "`#{ application }'"
  end
end
