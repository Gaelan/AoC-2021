#require 'set'

input = `pbpaste`

class Cave < Struct.new(:name, :tunnels)
  def big?
    name == name.upcase
  end
  def small?
    name == name.downcase
  end
  def end?
    name == "end"
  end
  def paths(excluding = [])
    return [[self]] if end?
    excluding = [self] + excluding if small?
    tunnels
      .filter { |tunnel| !excluding.include? tunnel }
      .map do |tunnel|
        tunnel.paths(excluding).map { |path| [self] + path }
      end
      .flatten(1)
  end
end

caves = {}
input.split("\n").each do |path|
  from, to = path.split("-")
  caves[from] ||= Cave.new(from, [])
  caves[to] ||= Cave.new(to, [])

  caves[from].tunnels << caves[to]
  caves[to].tunnels << caves[from]
end

paths = caves["start"].paths
paths.each { |p| p p.map(&:name) }
p paths.length
