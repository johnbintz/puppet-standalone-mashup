Facter.add('all_ip_addresses') do
  setcode do
    Facter.collection.list.find_all { |fact| fact[%r{^ipaddress_}] }.collect do |fact|
      Facter[fact].value
    end.compact.join(',')
  end
end

