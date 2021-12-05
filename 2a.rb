input = `pbpaste`
moves = input.split("\n").map { |x| dir, dist = x.split(" "); [dir.to_sym, dist.to_i] }
p moves

pos = 0
depth = 0

moves.each do |dir, dist|
  pos += dist if dir == :forward
  depth += dist if dir == :down
  depth -= dist if dir == :up
end

p pos
p depth
p pos * depth
