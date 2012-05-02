Capistrano::Configuration.instance.load do
  server '127.0.0.1:2222', :vagrant

  set(:user) { 'vagrant' }
  set(:password) { 'vagrant' }

  task :ensure_puppet do
    require 'socket'

    begin
      p = TCPSocket.new('localhost', 2222)
      p.close
    rescue Errno::ECONNREFUSED
      system %{vagrant up}
      p = TCPSocket.new('localhost', 2222)
      p.close
    end
  end

  before 'apply', 'ensure_puppet'
  before 'bootstrap', 'ensure_puppet'
end
