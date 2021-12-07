input = `pbpaste`

fish = [0] * 9

input.split(",").map(&:to_i).each { |age| fish[age] += 1 }

256.times do
  due = fish.shift
  fish[6] += due
  fish[8] = due
end

p fish.sum
