require 'pathname'

Puppet::Type.type(:sudoers_d).provide(:install) do
  desc "Install a sudoers.d file"

  def create
    temp_target.open('w') { |fh| fh.puts content }
    temp_target.chmod 0440
    temp_target.rename(target)
  end

  def destroy
    target.unlink
  end

  def exists?
    target.file? and target.read == content
  end

  private
  def target
    @target ||= Pathname("/etc/sudoers.d/#{@resource[:name]}")
  end

  def temp_target
    @temp_target ||= Pathname("/tmp/sudoers.d-#{@resource[:name]}-#{Time.now.to_f}")
  end

  def content
    @resource[:content]
  end
end

