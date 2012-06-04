module Puppet::Parser::Functions
  newfunction(:data_path, :type => :rvalue) do |args|
    File.join(lookupvar('::base::data_path'), *args)
  end
end

