require 'fileutils'

Puppet::Type.newtype(:bash_rc) do
  @doc = "An /etc/bash.bashrc file configured to also load from /etc/bash.bashrc.d/*.sh"

  ensurable

  newparam(:name) do
    desc "The useless name"
  end
end
