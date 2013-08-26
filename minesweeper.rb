class Minesweeper

  attr_accessor :size, :bomb_num

  def initialize(size, bomb_num)
    @size = size
    @bomb_num = bomb_num
    @board = []
  end

  def build_board
    @size.times do |x|
      @board[x] = []
      x.each do |y|
        square = Square.new(x, y)
        @board[x][y] = square
      end
    end
  end

  def fill_bombs
    placed_bombs = 0
    coordinates = (1..@size).to_a

    until placed_boms = @bomb_num
      x = coordinates.shuffle
      y = coordinates.shuffle

      unless @board[x][y].bomb
       @board[x][y].bomb = true
       placed_bombs += 1
      end
    end
  end

end
