require 'fileutils'

Puppet::Type.type(:make_and_install).provide(:action) do
  desc "Configure a program to install"

  def create
    system %{bash -c '#{path} cd #{@resource[:build_path]} ; make && make install'}
    File.symlink(@resource[:install_path], symlink_path)
  end

  def destroy
    FileUtils.rm_rf @resource[:install_path]
    FileUtils.rm_rf symlink_path
  end

  def exists?
    File.directory?(@resource[:install_path]) && File.symlink?(symlink_path)
  end

  private
  def symlink_path
    File.join(File.dirname(@resource[:install_path]), @resource[:name])
  end

  def path
    @resource[:path].empty? ? '' : "export PATH=#{@resource[:path]}:$PATH ; "
  end
end
