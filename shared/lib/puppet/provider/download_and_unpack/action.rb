Puppet::Type.type(:download_and_unpack).provide(:action) do
  desc "Download an unpack a remote repository"

  def create
    system %{bash -c 'cd #{@resource[:src_path]} ; (curl #{@resource[:url]} | tar #{tar_command} -)'}
  end

  def destroy
    FileUtils.rm_rf dir
  end

  def exists?
    File.directory?(dir)
  end

  private
  def file
    File.join(@resource[:src_path], File.basename(@resource[:url]))
  end

  def dir
    file.gsub(%r{\.tar\.(gz|bz2)$}, '')
  end

  def tar_command
    case @resource[:url]
    when /\.gz/
      "zxvf"
    when /\.bz2/
      "jxvf"
    else
      raise StandardError.new("Unknown format: #{@resource[:src_path]}")
    end
  end
end

