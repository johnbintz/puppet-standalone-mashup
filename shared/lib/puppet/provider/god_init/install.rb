require 'erb'

Puppet::Type.type(:god_init).provide(:install) do
  desc "Install a God script"

  def create
    FileUtils.mkdir_p File.dirname(file)

    File.open(file, 'wb') { |fh| fh.print processed_config }
  end

  def destroy
    File.unlink file
  end

  def exists?
    File.file?(file) && File.read(file) == processed_config
  end

  def processed_config
    ERB.new(config).result(binding)
  end

  private
  def file
    File.join(@resource[:dir], "#{@resource[:name]}.god")
  end

  def start
    @resource[:start] || ''
  end

  def stop
    @resource[:stop] || ''
  end

  def restart
    @resource[:restart] || ''
  end

  def name
    @resource[:name] || ''
  end

  def pid_file
    @resource[:pid_file] || ''
  end

  def interval
    @resource[:interval] || 5
  end

  def config
    <<-GOD
God.watch do |w|
  w.name = "<%= name %>"
  w.interval = <%= interval %>.seconds

  w.start = lambda { system("<%= start %>") }

  <% if !stop.empty? %>
    w.stop = lambda { system("<%= stop %>") ; system("killall -9 <%= name %>") }
  <% end %>

  <% if !restart.empty? %>
    w.restart = lambda { system("<%= restart %>") }
  <% end %>

  <% if pid_file %>
    w.pid_file = "<%= pid_file %>";
  <% else %>
    w.behavior(:clean_pid_file)
  <% end %>

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = <%= interval %>.seconds
      c.running = false
    end
  end
end
GOD
  end
end

