Puppet::Type.type(:bash_rc).provide(:install) do
  desc "Configure /etc/bash.bashrc to also load from /etc/bash.bashrc.d/*.sh"

  def create
    data.unshift %{for file in `find #{dir} -name "*.sh" -type f`; do source $file; done}
    data.unshift %{# #{file} managed by puppet}

    save

    FileUtils.mkdir_p dir
  end

  def destroy
    data.shift
    data.shift

    save

    FileUtils.rm_rf dir
  end

  def exists?
    data.first['puppet']
  end

  private
  def data
    @data ||= File.readlines(file)
  end

  def save
    File.open(file, 'wb') { |fh| fh.print data.collect(&:strip).join("\n") }
  end

  def file ; '/etc/bash.bashrc' ; end
  def dir ; '/etc/bash.bashrc.d' ; end
end

