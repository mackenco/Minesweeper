class Square
  attr_accessor :bomb, :display, :x, :y


  def initialize(x, y, bomb = false, display = "*")
    @x = x
    @y = y
    @bomb = bomb
    @display = display
  end

end