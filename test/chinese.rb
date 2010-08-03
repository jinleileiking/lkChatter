#$KCODE = "u"
#pattern = /([\u4e00-\u9fa5])/
#pattern =~ "你"
#data = Regexp.last_match
#if data
#  p data[0]
#  p data[1]
#end
#
#p data
require'iconv'
class String
  def to_gbk
    Iconv.iconv("GBK//IGNORE", "UTF-8//IGNORE", self).to_s
  end

  def to_utf8
    Iconv.iconv("UTF-8//IGNORE", "GBK//IGNORE", self).to_s
  end
end

s = [0x05d0].pack("U")
#p s

s = [0x4E00].pack("U")

#p s
#p s.class
#p s.to_gbk
#p s.to_utf8
e = [0x9FA5].pack("U")
#p e
regexp = /^([#{s}-#{e}\w]+)$/u

regexp =~ "你好啊aaasfsadfsd"



data = Regexp.last_match

if data

  puts data[0]

  puts data[1]

end



#p pattern.kcode
#p s=[0x4E00].pack("U")
#
#
#require 'stringio'
#
#$KCODE = "u"
#def truncate_utf8(text, length = 30, truncate_string = "...")
#  ios=StringIO.new(text)
#  ios.truncate(length*2)
#  ios.string << truncate_string
#end
#
#p truncate_utf8("english string", 2)
#
#p truncate_utf8("中文字符串", 2)
#
#p truncate_utf8("中文 and english", 6)
#
#p truncate_utf8("中文 and english",8)


#p "你".encoding

#
#utf8_string="\344\273\254"
#puts utf8_string #在irb中输出“浠”=>乱码
#puts utf8_string.to_gbk #在irb中输出“们”=>正确输出
##在irb输入一汉字
#gbk_string="\303\307"
#puts gbk_string #输出"们"
#p gbk_string.to_utf8 #输出"\344\273\254"
#
#class String
#def utf8?
#        unpack('U*') rescue return false
#        true
#end
#end
#
#p utf8_string.utf8? #true
#p gbk_string.utf8? #false
#
