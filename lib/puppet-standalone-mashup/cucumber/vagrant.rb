def vagrant(*args)
  system %{vagrant #{args.collect(&:to_s).join(' ')}}
end

def cap(*args)
  system %{cap vagrant #{args.collect(&:to_s).join(' ')}}
end

def bootstrap(hostname = ENV['HOSTNAME'])
  ENV['HOSTNAME'] = hostname
  system %{cap vagrant bootstrap}
end
