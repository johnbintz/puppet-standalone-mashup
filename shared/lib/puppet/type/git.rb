Puppet::Type.newtype(:git) do
  @doc = 'Cloning/pulling a git repo'

  ensurable

  newparam(:name) do
    desc "The name of the repo"
  end

  newparam(:repo) do
    desc "The address of the repo"
  end

  newparam(:cwd) do
    desc "The working directory into which the repo should be pulled"
  end

  newparam(:path) do
    desc "The binary search path"
  end

  newparam(:user) do
    desc "The user to perform the command as"
  end
end

