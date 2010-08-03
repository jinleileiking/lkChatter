$alive_info = []

$alive_info <<= {:ip => "10.86.10.44", :nickname => "lk"}
client_ip = "10.86.10.44"
nickname = "lll"

p $alive_info.collect {|x| x[:ip]}

$alive_info <<= {:ip => client_ip, :nickname => nickname} unless $alive_info.collect {|x| x[:ip]}.include?(client_ip)
p $alive_info

def $alive_info.ips
  $alive_info.collect {|x| x[:ip]}
end

def $alive_info.nicknames
  $alive_info.collect {|x| x[:nickname]}
end


p $alive_info.ips

p $alive_info.nicknames