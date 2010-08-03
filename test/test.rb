class Test
  def initialize
    @a = nil
  end
end

class Test
  attr_accessor :a
end

test = Test.new

test.a = "hi"

p test