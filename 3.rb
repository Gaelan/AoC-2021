lines = `pbpaste`.split("\n")

gamma = lines[0].length.times.map do |digit|
  digits = lines.map {|l| l[digit] }
  ones = digits.count { |d| d == "1" }
  zeroes = digits.count { |d| d == "0" }
  if ones > zeroes then "1" else "0" end
end.join("").to_i(2)

epsilon = lines[0].length.times.map do |digit|
  digits = lines.map {|l| l[digit] }
  ones = digits.count { |d| d == "1" }
  zeroes = digits.count { |d| d == "0" }
  if ones < zeroes then "1" else "0" end
end.join("").to_i(2)

p gamma
p epsilon
p gamma * epsilon

def find_rating(lines, digit, mode)
  return lines[0].to_i(2) if lines.size == 1
  digits = lines.map { |l| l[digit] }
  ones = digits.count { |d| d == "1" }
  zeroes = digits.count { |d| d == "0" }
  target = if mode == :oxygen
    if ones >= zeroes then "1" else "0" end
  else
    if ones >= zeroes then "0" else "1" end
  end
  lines = lines.filter { |l| l[digit] == target }
  find_rating(lines, digit + 1, mode)
end

p find_rating(lines, 0, :oxygen)
p find_rating(lines, 0, :co2)
p find_rating(lines, 0, :oxygen) * find_rating(lines, 0, :co2)
