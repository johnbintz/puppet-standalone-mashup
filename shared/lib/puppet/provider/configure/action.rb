Puppet::Type.type(:configure).provide(:action) do
  desc "Configure a program to install"

  def create
    command = %{bash -c "env ; sleep 10 ; cd #{@resource[:build_path]} && #{@resource[:preconfigure].gsub('"', '\\"')} #{path} ./configure --prefix=#{@resource[:install_path]} #{@resource[:options]}"}.tap { |o| p o }
    system command
    p $?
    puts command
    raise StandardError.new("Could not configure") if $?.exitstatus != 0
  end

  def destroy
    File.unlink config_status
  end

  def exists?
    return true if unless?

    File.file?(config_status)
  end
 
  private
  def config_status
    File.join(@resource[:build_path], @resource[:config_status])
  end

  def unless?
    return nil if !@resource[:unless] || @resource[:unless].empty?

    system %{bash -c '#{@resource[:unless]}'}

    $?.exitstatus == 0
  end

  def path
    @resource[:path].empty? ? '' : "PATH=#{@resource[:path]} "
  end
end

