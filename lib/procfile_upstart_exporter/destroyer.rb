class ProcfileUpstartExporter::Destroyer
  def initialize procfile_parser = ProcfileUpstartExporter::ProcfileParser.new
    self.procfile_parser = procfile_parser
  end

  def destroy application, path, procfile = nil
    ProcfileUpstartExporter.logger.debug 'Starting Upstart jobs deletion ' \
                                         "for `#{ application }'"
    if procfile
      destroy_jobs application, path, procfile_parser.parse(procfile)
                                                     .map(&:name)
    else
      destroy_all_jobs application, path
    end
    ProcfileUpstartExporter.logger.debug 'Deleted Upstart jobs for ' \
                                         "`#{ application }'"
  end

  private

  attr_accessor :procfile_parser

  def destroy_all_jobs application, path
    stopping_output = begin
      IO.popen(['stop', application], err: [:child, :out]).read
    rescue Errno::ENOENT
      "Upstart binary not found. #{application} not stopped."
    end
    ProcfileUpstartExporter.logger.debug stopping_output
    FileUtils.rm_rf File.join(path, "#{ application }.conf")
    FileUtils.rm_rf File.join(path, application)
  end

  def destroy_jobs application, path, processes_names
    Dir.glob("#{ path }/#{ application }/*.conf").each do |job_absolute_path|
      process_name = File.basename job_absolute_path, '.conf'
      unless processes_names.include? process_name
        job = File.join application, process_name
        stopping_output = begin
          IO.popen(['stop', job], err: [:child, :out]).read
        rescue Errno::ENOENT
          "Upstart binary not found. #{job} not stopped."
        end
        ProcfileUpstartExporter.logger.debug stopping_output
        FileUtils.rm_rf File.join(path, "#{ job }.conf")
      end
    end
  end
end
