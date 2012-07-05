Facter.add("varnish_cache_size") do
  setcode do
    %x{df -m /var}.lines.to_a.last.strip.split(/ +/)[1].to_i / 4
  end
end

