Puppet::Type.type(:bash_rc_d).provide(:install) do
  desc "Configure a new directory to be added to every user's PATH"

  def create
    file.open('wb') { |fh| fh.puts content }
  end

  def destroy
    file.unlink
  end

  def exists?
    file.file? && file.read == content
  end

  private
  def content
    "export PATH=#{@resource[:path]}/#{@resource[:name]}/sbin:#{@resource[:path]}/#{@resource[:name]}/bin:$PATH" 
  end

  def file
    Pathname("/etc/bash.bashrc.d/#{@resource[:name]}.sh")
  end
end

