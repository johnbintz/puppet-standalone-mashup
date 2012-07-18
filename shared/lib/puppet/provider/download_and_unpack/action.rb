Puppet::Type.type(:download_and_unpack).provide(:action) do
  desc "Download an unpack a remote repository"

  def create
    system %{bash -c 'mkdir -p #{@resource[:src_path]} ; cd #{@resource[:src_path]} ; (curl -L #{@resource[:url]} | tar #{tar_command} -)'}
    raise StandardError.new("Could not download") if $?.exitstatus != 0

    if original_name
      system %{bash -c 'cd #{@resource[:src_path]} && mv #{original_name} #{target_dir}'}
    end
  end

  def destroy
    FileUtils.rm_rf target_dir
  end

  def exists?
    return unless? if unless? != nil

    File.directory?(File.join(@resource[:src_path], target_dir))
  end

  private
  def unless?
    return nil if !@resource[:unless] || @resource[:unless].empty?

    system %{bash -c '#{@resource[:unless]}'}

    $?.exitstatus == 0
  end

  def file
    File.join(@resource[:src_path], File.basename(@resource[:url]))
  end

  def target_dir
    "#{@resource[:name]}-#{@resource[:version]}"
  end

  def dir
    file.gsub(%r{\.tar\.(gz|bz2)$}, '')
  end

  def original_name
    (@resource[:original_name] || '').empty? ? nil : @resource[:original_name]
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

