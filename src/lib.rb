require "rubygems"
require 'socket'               # Get sockets from stdlib
require 'pp'
require "yaml"

#def ip_to_int(ip_string)
#  pattern = /^(\d+).(\d+).(\d+).(\d+)/
#  pattern =~ ip_string
#  data = Regexp.last_match
#  if data
#    (data[1].to_i) *255 * 255 * 255 + (data[2].to_i) * 255 * 255 + (data[3].to_i) * 255 + (data[4].to_i)
#  end
#end

def hex_str2hex_octets(hex_str)
  hex_str.gsub(/../) {|s|  s + ":"}
end

def change_item(top, atxxx, position, item, value)
  eval ("@tmpa = #{top}.#{atxxx}")

  b = @tmpa[position]
  c = b.value
  eval ("c.#{item} = #{value}") if item
  eval ("c = #{value}") unless item

  b.value = c
  eval ("@tmpa[#{position}] = b")
  eval ("#{top}.#{atxxx} = @tmpa")
end

class Timer
  attr_accessor :sec
  attr_accessor(:timeout_time)

  def initialize( s, &block )
    @sec = s
    @on_timeout = block
    @current = nil
    @timer_thread = nil
    @timeout_time = 0
  end


  def start
    @current = Thread.current
    @timer_thread = Thread.fork {
      while true
        sleep @sec
        if @on_timeout then
          @on_timeout.call
        else
          @current.raise  "No timeout Method"
        end
        @timeout_time += 1
      end
    }
  end

  def stop
    if @timer_thread then
      Thread.kill @timer_thread
      @timer_thread = nil
      true
    else
      false
    end
  end

  def reset
    stop
    @timeout_time = 0
    start
  end

end


def dump_hex(b)
  if b.class == Fixnum
    b = sprintf("%02x", b)
  end
  if b.length % 2 != 0
    b.insert(0, "0")
  end
  c = b.gsub(/../) {|x| "0x#{x.upcase} " }
  c = c.strip
  c
end

def get_addresses(ip)
  pattern = /(.+)\.(.+)\.(.+)\.(.+)/
  pattern =~ ip.strip
  data = Regexp.last_match
  if data
    ips = []
    (2..254).each do |count|
      ips << [data[1], data[2], data[3], count].join(".")
    end
    ips
  end
end