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
    @flag_num = 0
    @pow = false
    @reveal_count = 0
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

  def run
    build_board
    fill_bombs
    print_board

    until over?
      user_input
      print_board
    end

  end

  def over?
    true if @pow || @reveal_count == ((@size**2) - @bomb_num)
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

  def flag(x,y)
    if @board[x][y].display == "F"
      @flag_num -= 1
      @board[x][y].display = "*"
    else
      @flag_num += 1
      @board[x][y].display = "F"
    end
  end

  def reveal(x,y)
    count = nil
    if @board[x][y].bomb
      @board[x][y].display = "X"
      @pow = true
    else
      neighbors = neighbors(x, y)
      count = count_bombs(neighbors)
      @board[x][y].display = count.to_s
      @reveal_count +=1
    end
    if count == 0
      @board[x][y].display = "0"
      neighbors.each { |neighbor| reveal(neighbor.x, neighbor.y) }
    end
  end

  def count_bombs(neighbors)
    neighbors.inject(0) { |total, neighbor| neighbor.bomb ? total + 1 : total }
  end

  def neighbors(x, y)

    neighbors = []

    POSSIBLE_NEIGHBORS.each do |poss|
      if (poss[0] + x).between?(0, @size-1) &&
                                            (poss[1] + y).between?(0, @size-1)
        square = board[poss[0] + x][poss[1] + y]
        neighbors << square unless ("0"...@size.to_s).include?(square.display)
      end
    end

    neighbors
  end

end

ms = Minesweeper.new(9, 10)

