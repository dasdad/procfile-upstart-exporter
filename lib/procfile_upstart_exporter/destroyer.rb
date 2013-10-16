class ProcfileUpstartExporter::Destroyer
  def destroy application, path
    Kernel.system 'stop', application
  end
end
