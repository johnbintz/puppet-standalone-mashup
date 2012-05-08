module Puppet::Parser::Functions
  newfunction(:share_path, :type => :rvalue) do |args|
    share_path(lookupvar('base::share_path'), *args)
  end
end

