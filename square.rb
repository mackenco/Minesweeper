class Square
  attr_accessor :bomb, :display, :x, :y

  def initialize(x, y, bomb = false, display = "*")
    @x = x
    @y = y
    @bomb = bomb
    @display = display
  end

  def flag
    @display == "F" ? @display = "*" : @display = "F"
  end

  def reveal(game)
    count = nil
    unless @display == "F"
      if @bomb
        @display = "X"
        game.pow = true
      else
        neighbors = game.neighbors(@x, @y)
        count = game.count_bombs(neighbors)
        @display = count.to_s
      end
      if count == 0
        @display = "0"
        neighbors.each { |neighbor| neighbor.reveal(game) }
      end
    end
  end

end