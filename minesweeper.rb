load 'square.rb'

class Minesweeper

  attr_accessor :size, :bomb_num, :board
  POSSIBLE_NEIGHBORS = [[0, 1], [0, -1],
                        [1, 0], [-1, 0],
                        [1, 1], [-1, -1],
                        [1, -1],[-1,1]]

  def initialize(size, bomb_num)
    @size = size
    @bomb_num = bomb_num
    @board = []
    @pow = false
    @reveal_count = 0
  end

  def run
    build_board
    fill_bombs
    print_board

    until over?
      user_input
      print_board
    end

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
      # x.each { |y| print y.display + " " }
      # puts ""
      x.each do |y|
        if y.bomb
          print "! "
        else
          print y.display + " "
        end
      end
      puts ""
    end
  end

  def over?
    @pow || check_victory == @bomb_num
  end

  def check_victory
    unrevealed_count = 0
    @board.each do |x|
      x.each do |y|
        unrevealed_count += 1 if ["*", "F"].include?(y.display)
      end
    end
    puts "Unreveal count is: #{unrevealed_count}"
    unrevealed_count
  end

  def user_input
    p "Do something"
    input = gets.chomp.split(" ")
    case input[0].upcase
    when "R"
      reveal(input[1].to_i, input[2].to_i)
    when "F"
      flag(input[1].to_i, input[2].to_i)
    end
  end

  def reveal(x,y)
    count = nil
    unless @board[x][y].display == "F"
      if @board[x][y].bomb
        @board[x][y].display = "X"
        @pow = true
      else
        neighbors = neighbors(x, y)
        count = count_bombs(neighbors)
        @board[x][y].display = count.to_s

      end
      if count == 0
        @board[x][y].display = "0"
        neighbors.each { |neighbor| reveal(neighbor.x, neighbor.y) }
      end
    end
  end

  def count_bombs(neighbors)
    neighbors.inject(0) { |total, neighbor| neighbor.bomb ? total + 1 : total }
  end

  def neighbors(x, y)
    neighbors = []
    POSSIBLE_NEIGHBORS.each do |poss|
      if on_board?(poss[0], x) && on_board?(poss[1], y)
        square = board[poss[0] + x][poss[1] + y]
        neighbors << square unless ("0"...@size.to_s).include?(square.display)
      end
    end
    neighbors
  end

  def on_board?(x1, x2)
    (x1 + x2).between?(0, @size - 1)
  end

  def flag(x,y)
    if @board[x][y].display == "F"
      @board[x][y].display = "*"
    else
      @board[x][y].display = "F"
    end
  end #move into Square
end

ms = Minesweeper.new(9 , 10)
ms.run

