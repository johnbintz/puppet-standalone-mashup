Puppet::Type.newtype(:sudoers_d) do
  @doc = "Add a file to /etc/sudoers.d"

  ensurable

  newparam(:name) do
    desc "The file to create"
  end

  newparam(:content) do
    desc "The content of the file"
  end
end

