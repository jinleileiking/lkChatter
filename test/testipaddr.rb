require "lib"
#
#ips = get_addresses(IPSocket.getaddress(Socket.gethostname))
#
#pp ips
#
#ips.each do |dest_ip|
#  next if dest_ip == IPSocket.getaddress(Socket.gethostname)
#  send_socket = UDPSocket.new
#  send_socket.connect(dest_ip, PORT)
#  send_socket.send "hello", 0
#  send_socket.close
#end


ips = get_addresses(IPSocket.getaddress(Socket.gethostname))
send_sockets = []

ips.each do |dest_ip|
  next if dest_ip == IPSocket.getaddress(Socket.gethostname)
  send_socket = UDPSocket.new
  send_socket.connect(dest_ip, PORT)
  send_sockets << send_socket
end

#定时发送keep_alive信息
send_sockets.each do |send_socket|
  $log.debug "send keep alive to #{send_socket}"
  send_socket.send "type=keepalive\r\n", 0
end
sleep(5)
