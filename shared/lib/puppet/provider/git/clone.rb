Puppet::Type.type(:git).provide(:clone) do
  desc "Clone/pull a git repo"

  def create
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
    user_switch = @resource[:user] ? "sudo -u #{@resource[:user]} -- " : ""

    %{bash -c 'PATH=#{@resource[:path]} #{user_switch} git #{what}'}
  end

  def path
    File.join(@resource[:cwd], @resource[:name])
  end
end

