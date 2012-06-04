Facter.add("osfamily") do
  setcode do
    distid = Facter.value('lsbdistid') || Facter.value('operatingsystem')
    case distid
    when /RedHat|CentOS|Fedora/
      "redhat"
    when "ubuntu"
      "debian"
    else
      distid.downcase
    end
  end
end

