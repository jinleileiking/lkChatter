require 'lib'
require "userinfo"

Thread.abort_on_exception = true

PORT = 717
IP_NUMBER = 9


require 'log4r'
include Log4r
$log = Logger.new ''
$log.outputters = Outputter.stdout
$log.level = DEBUG


$send_queue = Queue.new
$text_show_queue = Queue.new
$user_info = UserInfo.new
$nickname_queue = Queue.new
$tray_icon_queue = Queue.new

$alive_info = []
$ips = []

def $alive_info.ips
  $alive_info.collect {|x| x[:ip]}
end

def $alive_info.nicknames
  $alive_info.collect {|x| x[:nickname]}
end

if File.exist?("config.yaml")
  config  =  YAML.load(File.open("config.yaml"))
#  pp config

  $user_info.nickname = config[:nickname]

  config[:ips].each do |ip|
    $ips = $ips.concat get_addresses(ip) unless  ip.empty?
  end
else
  $user_info.nickname = "unknown"
  $text_show_queue.enq "没有进行配置，请先进行配置!\r\n目前以'unknown'为昵称和本网段进行群聊!\r\n"
end

host_ips = get_addresses(IPSocket.getaddress(Socket.gethostname))
$ips = $ips.concat host_ips
$ips.uniq

#pp $ips