module Puppet::Parser::Functions
  newfunction(:config_path, :type => :rvalue) do |args|
    File.join(lookupvar('::base::config_path'), *args)
  end
end
