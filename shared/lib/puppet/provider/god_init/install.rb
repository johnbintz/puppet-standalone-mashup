require 'erb'

Puppet::Type.type(:god_init).provide(:install) do
  desc "Install a God script for a non-daemonized process"

  def self.def_resources(*args)
    args.each do |arg|
      class_eval <<-RB
        def #{arg}
          @resource[:#{arg}] || ''
        end
      RB
    end
  end

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

  def_resources :start, :group, :name, :dir

  def interval
    @resource[:interval] || 30
  end

  private
  def file
    File.join(dir, "#{name}.god")
  end

  def config
    <<-GOD
God.watch do |w|
  w.name = "<%= name %>"
  <% if !group.empty? %>
    w.group = "<%= group %>"
  <% end %>

  w.interval = <%= interval %>.seconds

  w.start = %{<%= start %>}

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

