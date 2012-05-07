Puppet::Type.newtype(:download_and_unpack) do
  @doc = "A downloaded file, unpacked"

  ensurable

  newparam(:name) do
    desc "The name of the file"
  end

  newparam(:url) do
    desc "The source of the file"
  end

  newparam(:src_path) do
    desc "The location where the file should be downloaded"
  end

  newparam(:version) do
    desc "The version to install"
  end

  newparam(:original_name) do
    desc "The directory name that the software unpacks as"
  end

  newparam(:unless) do
    desc "If provided, don't run the download unless this condition is true"
  end
end

