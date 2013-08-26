require 'yaml'
load 'square.rb'

class Minesweeper

  attr_accessor :size, :bomb_num, :board, :pow
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
    @start_time = 0
    @cheat_mode = false
    @new = true
  end

  def run
    if @new
      build_board
      fill_bombs
      start_timer
      @new = false
    end

    print_board

    until over?
      user_input
      print_board
    end
    display_outcome

  end

  def start_timer
    @start_time = Time.now
  end

  def display_outcome
    if @pow
      puts 'You lose.'
    else
      puts 'You win!'
      puts "You took #{Time.now-@start_time} seconds!"
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

  def print_cheat_board
    print "   "
    (0...@size).each {|i| print '%02d'% i + " "}
    puts ""
    @board.each_with_index do |x, i|
      print '%02d'% i + "|"
      x.each do |y|
        if y.bomb
          print "!  "
        else
          print y.display + "  "
        end
      end
      puts ""
    end
  end

  def print_normal_board
    print "   "
    (0...@size).each {|i| print '%02d'% i + " "}
    puts ""
    @board.each_with_index do |x, i|
      print '%02d'% i + "|"
      x.each { |y| print y.display + "  " }
      puts ""
    end
  end

  def print_board
    @cheat_mode ? print_cheat_board : print_normal_board
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
    puts "Spaces to clear: #{unrevealed_count-@bomb_num}"
    unrevealed_count
  end

  def user_input
    p "Do something"
    input = gets.chomp.split(" ")
    @cheat_mode = true if input[0] == "winwinwin"
    current_square = @board[input[2].to_i][input[1].to_i]
    case input[0].upcase
    when "R"
      current_square.reveal(self)
    when "F"
      current_square.flag
    when "S"
      save
    end
  end

  def save
    File.open('minesweeper_saves.txt', 'w') {|file| file.puts self.to_yaml}
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

end

puts "MINESWEEPER: Do you want to start a new game or load an existing game?"
input = gets.chomp
case input
when 'load'
  file = File.read("minesweeper_saves.txt")
  ms = YAML::load(file)
when 'start'
  puts "What size board do you want?"
  board_size = gets.chomp.to_i
  puts "How many bombs do you want?"
  bombs = gets.chomp.to_i
  ms = Minesweeper.new(board_size, bombs)
end

ms.run


