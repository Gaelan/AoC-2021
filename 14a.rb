input = `pbpaste`

Rule = Struct.new(:from, :to)

template, rules = input.split("\n\n")
rules = rules.split("\n").map { |rule| Rule.new(*rule.split(" -> ")) }

polymer = template
10.times do
  rules.each do |rule|
    result = "#{rule.from[0]}#{rule.to.downcase}#{rule.from[1]}"
    polymer.gsub!(rule.from, result)
    polymer.gsub!(rule.from, result)
  end
  p polymer
  polymer.upcase!
  p polymer
  p polymer.length
end

counts = Hash.new 0
polymer.chars.each { |char| counts[char] += 1 }
p counts.values.max - counts.values.min
