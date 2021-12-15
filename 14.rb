input = `pbpaste`

Rule = Struct.new(:from, :to)

def merge(h1, h2)
  h1.merge(h2) { |_, a, b| a + b }
end

def values_between(a, b, rules, iters, cache)
  pair = "#{a}#{b}"
  cache[iters] ||= {}
  cached = cache[iters][pair]
  return cached unless cached.nil?

  return {} if iters == 0

  middle = rules.find { |rule| rule.from == pair }.to

  us = { middle => 1 }

  left = values_between(a, middle, rules, iters - 1, cache)
  right = values_between(middle, b, rules, iters - 1, cache)

  #p iters, cache[iters].length

  ret = merge(us, merge(left, right))
  cache[iters][pair] = ret
  ret
end

template, rules = input.split("\n\n")
rules = rules.split("\n").map { |rule| Rule.new(*rule.split(" -> ")) }
cache = {}

pairs = template.chars.zip(template.chars.drop(1))
totals = pairs.map do |a, b|
  if b
    values_between(a, b, rules, 40, cache)
  else
    {}
  end
end.inject({}) { |a, b| merge(a, b) }

orig_counts = Hash.new 0
template.chars.each { |char| orig_counts[char] += 1 }

totals = merge(totals, orig_counts)

p totals
p totals.values.max - totals.values.min

