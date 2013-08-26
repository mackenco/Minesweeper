class Minesweeper

  attr_accessor :size, :bomb_num

  def initialize(size, bomb_num)
    @size = size
    @bomb_num = bomb_num
  end

  def build_board
    @size.times do |x|
      x = []
      x.each do |y|
        square = Square.new(x, y)
        x[y] = square
      end
    end
  end

  def fill_bombs
    placed_bombs = 0
    coordinates = (1..@size).to_a

    until placed_boms = @bomb_num
      x = coordinates.shuffle
      y = coordinates.shuffle

      unless self[x][y].bomb
       self[x][y].bomb = true
       placed_bombs += 1
      end
    end
  end

end
