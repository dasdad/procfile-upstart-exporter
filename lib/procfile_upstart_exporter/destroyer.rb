class ProcfileUpstartExporter::Destroyer
  def destroy application, path
    ProcfileUpstartExporter.logger.debug 'Starting Upstart jobs deletion'
                                         "for `#{ application }'"
    stopping_output = IO.popen(['stop', application], err: [:child, :out]).read
    ProcfileUpstartExporter.logger.debug stopping_output
    FileUtils.rm_rf File.join(path, "#{ application }.conf")
    FileUtils.rm_rf File.join(path, application)
    ProcfileUpstartExporter.logger.debug 'Deleted Upstart jobs for ' \
                                         "`#{ application }'"
  end
end
