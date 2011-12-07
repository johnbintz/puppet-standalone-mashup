Puppet::Type.newtype(:bash_rc_d) do
  @doc = "A /etc/bash.bashrc.d/*.sh file, used to add vendored applications to the path"

  ensurable

  newparam(:name) do
    desc "The name of the application to add"
  end

  newparam(:path) do
    desc "The base path for vendored applications"
  end
end

