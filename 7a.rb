input = `pbpaste`

crabs = input.split(",").map(&:to_i)

def cost(crabs, pos)
  crabs.map { |crab| (crab - pos).abs }.sum
end

cheapest = ((crabs.min)..(crabs.max)).min_by { |pos| cost(crabs, pos) }
p cheapest
p cost(crabs, cheapest)
