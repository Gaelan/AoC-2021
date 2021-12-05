input = `pbpaste`
calls, *boards = input.split("\n\n")

calls = calls.split(",").map(&:to_i)
boards = boards.map do |board|
  lines = board.split("\n").map { |line| line.strip.split(/ +/).map(&:to_i) }
end
p calls
p boards

def board_winning(board, calls)
  # rows
  board.each do |row|
    return true if row.all? { |n| calls.include? n }
  end

  # cols
  5.times do |col|
    col = board.map { |row| row[col] }
    return true if col.all? { |n| calls.include? n }
  end
 
  return false
end

calls_so_far = []
calls.each do |call|
  calls_so_far << call
  winning_board = boards.find { |board| board_winning(board, calls_so_far) }
  if winning_board
    p winning_board
    sum = winning_board.flatten.find_all { |n| !calls_so_far.include? n }.sum
    p sum
    p calls_so_far.last
    p sum * calls_so_far.last
  end
end
 
