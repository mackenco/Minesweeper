class Square
  attr_accessor :bomb, :display

  def initialize(x, y, bomb = false, display = "*")
    @x = x
    @y = y
    @bomb = bomb
    @display = display
  end

end