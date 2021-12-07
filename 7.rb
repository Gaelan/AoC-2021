input = `pbpaste`

crabs = input.split(",").map(&:to_i)

def move_cost(dist)
  (1..dist).sum
end

def cost(crabs, pos)
  crabs.map { |crab| move_cost((crab - pos).abs) }.sum
end

cheapest = ((crabs.min)..(crabs.max)).min_by { |pos| cost(crabs, pos) }
p cheapest
p cost(crabs, cheapest)
