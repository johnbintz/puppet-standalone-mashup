module Puppet::Parser::Functions
  newfunction(:log_path, :type => :rvalue) do |args|
    File.join(lookupvar('::base::log_path'), *args)
  end
end

