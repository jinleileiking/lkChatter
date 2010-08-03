require  'socket'
$port  =  4321
server_thread  =  Thread.start  do #  run  server  in  a  thread
server  =  UDPSocket.open
server.bind(nil,  $port)
2.times  {  p  server.recvfrom(64)  }
end
#  Ad-hoc  client
UDPSocket.open.send("ad  hoc",  0,  '10.86.10.44',  $port)
#  Connection  based  client
sock  =  UDPSocket.open
sock.connect('10.86.10.44',  $port)
sock.send("connection-based",  0)
server_thread.join