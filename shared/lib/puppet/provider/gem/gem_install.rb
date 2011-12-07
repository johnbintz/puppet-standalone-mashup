Puppet::Type.type(:gem).provide(:install) do
  desc "Install a Ruby Gem"

  def create
    gem_command('install --no-ri --no-rdoc')
  end

  def destroy
    system gem_command('uninstall -x -I')
  end

  def exists?
    system gem_command('list -i')
    $?.exitstatus == 0
  end

  private
  def version
    version = ''
    if @resource[:version] && !@resource[:version].empty?
      version = " -v #{@resource[:version]}"
    end
    version
  end

  def gem_command(what)
    command = %{bash -c 'PATH=#{@resource[:path]} gem #{what} #{@resource[:name]} #{version}'}
    %x{#{command}}
  end
end

