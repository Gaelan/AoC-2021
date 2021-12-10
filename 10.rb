lines = `pbpaste`.split("\n")

PAIRS = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}
SCORES = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}
AUTOCOMPLETE_SCORES = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

def line_status(line)
  stack = []
  line.chars.each do |char|
    if char == stack[-1]
      stack.pop
    elsif PAIRS[char] != nil
      stack.push PAIRS[char]
    else
      return [:corrupted, char]
    end
  end
  if stack == []
    return [:valid]
  else
    return [:incomplete, stack.reverse.join]
  end
end

statuses = lines.map { |line| line_status(line) }

puts "part 1"
p (statuses.filter do |status, _|
  status == :corrupted
end.map do |_, char|
  SCORES[char]
end.sum)

puts "part 2"
scores = statuses.filter do |status, _|
  status == :incomplete
end.map do |_, completion|
  completion.chars.inject(0) do |score, char|
    (score * 5) + AUTOCOMPLETE_SCORES[char]
  end
end
p scores.sort[scores.length / 2]
