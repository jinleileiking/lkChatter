content = " nickname=leiking&message=ffsadfdsafeasdfasdfsadfsafdasdfsadfsadfasfdsadfsadfasdfsadfsadfsadf"

pattern = /^nickname=(\w+)&message=(.+)/
pattern =~ content.strip
data = Regexp.last_match
if data
  puts "Message: #{data[2]} from #{data[1]}"
end

  