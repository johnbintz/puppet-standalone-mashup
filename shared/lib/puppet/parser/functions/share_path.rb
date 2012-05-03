module Puppet::Parser::Functions
  newfunction(:share_path, :type => :rvalue) do |args|
    File.join(lookupvar('base::share_path'), *args)
  end
end

