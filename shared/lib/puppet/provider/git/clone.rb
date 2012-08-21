Puppet::Type.type(:git).provide(:clone) do
  desc "Clone/pull a git repo"

  def create
    system key_check_command

    if $?.exitstatus != 0
      system keyscan_command
    end

    if File.directory?(path)
      Dir.chdir(path) { system git_command("pull origin master") }
    else
      Dir.chdir(@resource[:cwd]) { system git_command("clone #{@resource[:repo]}") }
    end
  end

  def destroy
    FileUtils.rm_rf(path) if File.directory?(path)
  end

  def exists?
    false
  end

  private
  def git_command(what)
    path_wrap("git #{what}")
  end

  def keyscan_command
    path_wrap("ssh-keyscan -t dsa,rsa #{@resource[:host]} >> ~/.ssh/known_hosts")
  end

  def key_check_command
    path_wrap("ssh-keygen -F #{@resource[:host]}")
  end

  def path_wrap(command)
    command = %{PATH=#{@resource[:path]} #{command}}

    if @resource[:user]
      command = %{su -c "#{command}" #{@resource[:user]}}
    else
      command = %{sh -c "#{command}"}
    end

    command
  end

  def path
    File.join(@resource[:cwd], @resource[:name])
  end
end

