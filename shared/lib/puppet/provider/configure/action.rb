Puppet::Type.type(:configure).provide(:action) do
  desc "Configure a program to install"

  def create
    system %{bash -c '#{path} cd #{@resource[:build_path]} ; #{@resource[:preconfigure]} ./configure --prefix=#{@resource[:install_path]} #{@resource[:options]}'}.tap { |o| p o }
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
    return nil if @resource[:unless].empty?

    system %{bash -c '#{@resource[:unless]}'}
    $?.exitstatus == 0
  end

  def path
    @resource[:path].empty? ? '' : "export PATH=#{@resource[:path]}:$PATH ; "
  end
end

