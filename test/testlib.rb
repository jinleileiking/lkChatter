require "lib"
#
#class T_ReaderParamConfig < BitStruct
#  hex_octets :achReaderName, 20 * 8, 'achReaderName'
#  unsigned :ucManufacturerName, 1 * 8, 'ucManufacturerName'
#  unsigned :ucReaderModel, 1 * 8, 'ucReaderModel'
#  unsigned :ucPad, 1 * 8, 'ucPad'
#  unsigned :ucBoardSerialId, 1 * 8, 'ucBoardSerialId'
#  unsigned :dwBoardSerialIdP, 1 * 32, 'dwBoardSerialIdP'
#  unsigned :dwBoardSerialIdA, 1 * 32, 'dwBoardSerialIdA'
#end
#
#
#
#class Packet < BitStruct
#  vector :atReaderParamConfig, "a vector", :length => 5 do
#    nest :value, T_ReaderParamConfig
#  end
#end
#
#@pkt = Packet.new
#change_item("@pkt", "atReaderParamConfig", 1, "ucManufacturerName", 222)
#require "pp"
#pp @pkt
#
#
#
#timer = Timer.new(4) do
#  puts Time.new.sec
#  puts "hello"
#end
#
#timer.start
#
#
#while true
#
#  timer.reset if Time.new.sec == 17
#end

p dump_hex("0001")
p dump_hex("001")