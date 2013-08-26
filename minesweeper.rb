load 'square.rb'

class Minesweeper

  attr_accessor :size, :bomb_num, :board

  def initialize(size, bomb_num)
    @size = size
    @bomb_num = bomb_num
    @board = []
  end

  def build_board
    @size.times do |x|
      @board[x] = []

      @size.times do |y|
        square = Square.new(x, y, false)
        @board[x][y] = square
      end
    end
  end

  def fill_bombs
    placed_bombs = 0
    coordinates = (0...@size).to_a

    until placed_bombs == @bomb_num
      x = coordinates.sample
      y = coordinates.sample
      unless @board[x][y].bomb

       @board[x][y].bomb = true
       placed_bombs += 1
      end
    end
  end

  def print_board
    @board.each do |x|
      x.each { |y| print y.display + " " }
      puts ""
    end
  end

  def run
    build_board
    fill_bombs
    print_board

    until @flag_num == @bomb_num
      user_input
    end

    check_victory #will

  end

  def user_input
    p "Do something"
    input = gets.chomp
    case input[0]
    when "r"
      reveal(input[1], input[2])
    when "f"
      flag(input[1], input[2])
    end
  end

end

ms = Minesweeper.new(9, 10)

