require 'erb'

def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

module PuppetStandaloneMashup
  BASE = Pathname(File.expand_path('../../..', __FILE__))
end

require 'capistrano/command'

module Capistrano
  class Command
    alias :_replace_placeholders :replace_placeholders

    def replace_placeholders(command, channel)
      command = _replace_placeholders(command, channel)
      command.gsub!('$CAPISTRANO:TARGETHOSTNAME$', channel[:server].options[:target_hostname] || '')
      command
    end
  end
end

Capistrano::Configuration.instance.load do
  _cset(:puppet_dir) { '/tmp/puppet' }
  _cset(:additional_puppet_bin_path) { nil }

  _cset(:base_dir) { '/usr/local' }
  _cset(:src_dir) { '/usr/src' }

  _cset(:rename_server) { true }
  _cset(:use_sudo) { true }
  _cset(:additional_modules) { [] }
  _cset(:additional_puppet_options) { '' }

  @dir_made = false

  def sudo
    use_sudo ? "sudo -p 'sudo password: '" : ""
  end

  desc "Clear specified source directories"
  task :clear_source do
    run "cd #{src_dir} && #{sudo} rm -Rf #{sources}"
  end

  desc "Clear specified apps"
  task :clear_apps do
    run "cd #{base_dir} && #{sudo} rm -Rf #{apps}"
  end

  desc "Copy files to the remote server"
  task :copy_files do
    top.copy
    top.copy_shared
    top.copy_skel
  end

  desc "Apply the configuration"
  task :apply do
    top.copy_files
    top.rename if rename_server && wrong_server_name?

    run "cd #{puppet_dir} && #{sudo} ./apply"
  end

  def wrong_server_name?
    capture("hostname").strip
  end

  desc "Bootstrap the server"
  task :bootstrap do
    top.copy_files
    top.rename if rename_server

    run "cd #{puppet_dir} && #{sudo} ./bootstrap"
    top.reboot
  end

  desc "Reboot the server after bootstrapping"
  task :reboot do
    run "#{sudo} shutdown -r now"
  end

  desc "Rename the server"
  task :rename do
    hostname = ENV['HOSTNAME'] || fetch(:hostname, nil) || Capistrano::CLI.ui.ask("Hostname: ")

    top.copy_skel
    run "cd #{puppet_dir} && #{sudo} ./rename #{hostname}"
  end

  desc "Copy puppet configs to remote server"
  task :copy do
    top.ensure_puppet_dir

    Dir["*"].each do |file|
      if !%w{vbox deb}.include?(file)
        top.upload file, File.join(puppet_dir, file)
      end
    end
  end

  desc "Copy skel files to remote server"
  task :copy_skel do
    top.ensure_puppet_dir

    [ '*.erb', "#{distribution}/*.erb" ].each do |dir|
      Dir[PuppetStandaloneMashup::BASE.join('skel').join(dir).to_s].each do |file|
        data = StringIO.new(ERB.new(File.read(file)).result(binding))

        top.upload data, target = File.join(puppet_dir, File.basename(file, '.erb'))

        run "chmod a+x #{target}"
      end
    end
  end

  desc "Copy shared"
  task :copy_shared do
    top.ensure_puppet_dir

    run "mkdir -p #{puppet_dir}/shared/additional-modules"

    (%w{lib modules templates} + additional_modules.collect { |dir| "additional-modules/#{dir}" }).each do |dir|
      top.upload PuppetStandaloneMashup::BASE.join('shared', dir).to_s, File.join(puppet_dir, 'shared', dir)
    end
  end

  desc "Ensure Puppet target dir exists"
  task :ensure_puppet_dir do
    if !@dir_made
      run "#{sudo} rm -Rf #{puppet_dir}"
      run "mkdir -p #{puppet_dir}"

      @dir_made = true
    end
  end

  desc "Make sudo nice"
  task :make_sudo_nice do
    make_nice = "~/make_nice"

    run %{echo "%sudo ALL=NOPASSWD: /bin/rm, /tmp/puppet/apply" > #{make_nice}}
    run %{#{sudo} chmod 440 #{make_nice}}
    run %{#{sudo} chown root:root #{make_nice}}
    run %{#{sudo} mv ~/make_nice /etc/sudoers.d/}
  end

  def with_additional_puppet_bin_path
    additional_puppet_bin_path ? %{PATH="#{additional_puppet_bin_path}:$PATH"} : ''
  end
end

