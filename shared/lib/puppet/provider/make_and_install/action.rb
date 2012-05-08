require 'fileutils'

Puppet::Type.type(:make_and_install).provide(:action) do
  desc "Configure a program to install"

  def create
    system %{bash -c '#{path} cd #{@resource[:build_path]} ; make && make install'}

    FileUtils.rm_rf symlink_path
    FileUtils.ln_sf(@resource[:install_path], symlink_path)
  end

  def destroy
    FileUtils.rm_rf @resource[:install_path]
    FileUtils.rm_rf symlink_path
  end

  def exists?
    return true if unless?

    File.directory?(@resource[:install_path]) && File.symlink?(symlink_path)
  end

  private
  def unless?
    return nil if @resource[:unless].empty?

    system %{bash -c '#{@resource[:unless]}'}
    $?.exitstatus == 0
  end

  def symlink_path
    File.join(File.dirname(@resource[:install_path]), @resource[:name])
  end

  def path
    @resource[:path].empty? ? '' : "export PATH=#{@resource[:path]}:$PATH ; "
  end
end
