require_relative '../procfile-upstart-exporter'
require 'thor'

class ProcfileUpstartExporter::Cli < Thor
  class_option :verbose, type: :boolean

  def initialize(*)
    super
    self.creator   = ProcfileUpstartExporter::Creator.new
    self.destroyer = ProcfileUpstartExporter::Destroyer.new
  end

  desc 'create', 'Create Upstart jobs configuration'
  option :application, default: File.basename(Dir.pwd)
  option :procfile, default: 'Procfile'
  option :log, default: '/var/log'
  option :environment, default: '.env'
  option :user, default: 'app'
  option :path, default: '/etc/init'
  def create
    destroy
    creator.create options[:application],
                   options[:procfile],
                   options[:log],
                   options[:environment],
                   options[:user],
                   options[:path]
  end

  desc 'destroy', 'Delete Upstart jobs configuration'
  option :application, default: File.basename(Dir.pwd)
  option :path, default: '/etc/init'
  def destroy
    enter_verbose_mode if options[:verbose]
    destroyer.destroy options[:application], options[:path]
  end

  private

  attr_accessor :creator
  attr_accessor :destroyer

  def enter_verbose_mode
    ProcfileUpstartExporter.logger.level = Logger::DEBUG
  end
end
