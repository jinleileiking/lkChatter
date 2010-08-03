require 'lib'
TCPSocket.open("localhost", 21653) do |socket| # Use block form of open
  while true
    socket.puts "name=leiking"
    socket.puts "content=hello"
    sleep 1
  end
end