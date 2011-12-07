require 'erb'

Puppet::Type.type(:god_init).provide(:install) do
  desc "Install a God script"

  def create
    File.open(file, 'wb') { |fh| fh.print(ERB.new(config).result(binding)) }
  end

  def destroy
    File.unlink file
  end

  def exists?
    File.file? file
  end

  private
  def file
    "/etc/god.d/#{@resource[:name]}.god"
  end

  def start
    @resource[:start] || ''
  end

  def stop
    @resource[:stop] || ''
  end

  def name
    @resource[:name] || ''
  end

  def pid_file
    @resource[:pid_file] || ''
  end

  def config
    <<-GOD
God.watch do |w|
  w.name = "<%= name %>"
  w.interval = 15.seconds

  w.start = lambda { system("<%= start %>") }
  w.start_grace = 15.seconds

  <% if !stop.empty? %>
    w.stop = lambda { system("<%= stop %>") }
    w.stop_grace = 15.seconds
  <% end %>

  <% if pid_file %>
    w.pid_file = "<%= pid_file %>";
  <% else %>
    w.behavior(:clean_pid_file)
  <% end %>

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
end
GOD
  end
end

