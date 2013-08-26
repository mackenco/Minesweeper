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
        square = Square.new([x,y])
        x[y] = square
      end
    end
  end

end
