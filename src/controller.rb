require 'global'




def process_receive_message(client_ip, content)

  if client_ip == IPSocket.getaddress(Socket.gethostname)
    return
  end

  pattern = /type=keepalive&nickname=(.+)/
  pattern =~ content.strip
  data = Regexp.last_match
  if data
    $log.info "#{client_ip}: Keep alive! from user: #{data[1]}"
    process_keepalive client_ip, data[1]
  end

  pattern = /nickname=(.+)&message=(.+)/
  pattern =~ content.strip
  data = Regexp.last_match
  if data
    $log.info "#{client_ip}: Message: #{data[2]} from #{data[1]}"
    process_message client_ip, data[1], data[2]
  end

end

def process_message(client_ip, nickname, message)

  process_keepalive client_ip, nickname

  #update user alive view
  $text_show_queue.enq "|message|#{Time.new.strftime("[%H:%M:%S]")}#{nickname}: #{message}\r\n"

  #if the window is min,then flash
  $tray_icon_queue.enq "flash"

end

def process_keepalive(client_ip, nickname)
  #store alive ips
  unless $alive_info.ips.include?(client_ip)
    $alive_info <<= {:ip => client_ip, :nickname => nickname, :time_out => 0}
    $text_show_queue.enq "#{Time.new.strftime("[%H:%M:%S]")}#{nickname}(#{client_ip})上线了\r\n"
  end

  $alive_info.each do |item|
    if item[:ip] == client_ip
      if item[:nickname] != nickname
        $text_show_queue.enq "#{Time.new.strftime("[%H:%M:%S]")}#{item[:nickname]}(#{item[:ip]})改名为#{nickname}(#{client_ip})\r\n"
        item[:nickname] = nickname
      end
    end
  end

  $alive_info.each do |item|
    item[:time_out] = 0 if item[:ip] == client_ip
  end

end

#Receive thread
Thread.new do
  receive_socket = UDPSocket.new
  receive_socket.bind(IPSocket.getaddress(Socket.gethostname), PORT)
  while true
#    IO.select([receive_socket])
    content, address = receive_socket.recvfrom(1024)
    client_ip = address[3]
    content = content.chomp
    $log.debug "Receive from: #{client_ip} : #{content}"
    process_receive_message(client_ip, content)
  end
end


#nickname update
Thread.new do
  while true
    #update nicknames
    $log.debug "enq nickname : #{$alive_info.nicknames.inspect}"
    arr = $alive_info.collect {|item| "#{item[:nickname]}(#{item[:ip]})" }
    $nickname_queue.enq(arr)
    sleep(10)
  end
end

#check keepalive ips
Thread.new do
  while true
    sleep(30)
    $alive_info.each do |alive|
      alive[:time_out] += 1
      if alive[:time_out] == 12
        $text_show_queue.enq "#{Time.new.strftime("[%H:%M:%S]")}#{alive[:nickname]}(#{alive[:ip]})已经下线\r\n"
        $alive_info.delete  alive
      end
    end
  end
end

#Keepalive Thread
Thread.new do


  while true
    $ips.each do |dest_ip|
      next if dest_ip == IPSocket.getaddress(Socket.gethostname)
      send_socket = UDPSocket.new
      send_socket.connect(dest_ip, PORT)
      send_socket.send "type=keepalive&nickname=#{$user_info.nickname}\r\n", 0
#    dest_ip = send_socket.peeraddr[3]
#      send_socket.close
#      puts "send keep alive to #{dest_ip}"
#      $log.debug "send keep alive to #{dest_ip}"
      sleep(0.05)
    end
    sleep(5)
  end

end

#send thread
Thread.new do
  while true
    #get message
    if message = $send_queue.deq
      $alive_info.ips.each do |dest_ip|
        send_socket = UDPSocket.new
        send_socket.connect(dest_ip, PORT)
        send_socket.send message, 0
      end
    end
  end
end

require "view"
