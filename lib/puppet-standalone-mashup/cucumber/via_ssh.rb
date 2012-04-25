require 'net/ssh'

def via_ssh(&block)
  result = nil

  Net::SSH.start('localhost', @sugarpuck[:username], :password => @sugarpuck[:password], :port => @sugarpuck[:port]) do |ssh|
    result = block.call(ssh)
    result = result.strip if result.respond_to?(:strip)
  end

  result
end

