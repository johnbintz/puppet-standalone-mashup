Capistrano::Configuration.instance.load do
  server '127.0.0.1:2222', :vagrant

  ssh_options[:port] = 2222

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

  desc "Fix DNS resolution if bitten by the VirtualBox DNS bug"
  task :fix_dns do
    result = capture("ping -w 1 -W 1 -c 1 -q google.com; echo $?").lines.to_a.last.strip
    if result.to_i != 0
      run "#{sudo} sed -i 's#10.0.2.3#10.0.2.2#g' /etc/resolv.conf"
      result = capture("ping -w 1 -W 1 -c 1 -q google.com; echo $?").lines.to_a.last.strip

      if result.to_i != 0
        raise StandardError.new("Unable to fix DNS to get around VirtualBox DNS bug.")
      end
    end
  end

  before 'apply', 'ensure_puppet', 'fix_dns'
  before 'bootstrap', 'ensure_puppet', 'fix_dns'
end

