Puppet::Type.newtype(:gem) do
  @doc = 'A Ruby Gem'

  ensurable

  newparam(:name) do
    desc "The name of the gem"
  end

  newparam(:version) do
    desc "The version of the gem"
  end

  newparam(:path) do
    desc "The binary search path"
  end

  newparam(:options) do
    desc "Gem install options"
  end
end

