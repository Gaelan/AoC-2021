require 'set'

input = `pbpaste`

DIGIT_PATTERNS = %w(
  ABCEFG
  CF
  ACDEG
  ACDFG
  BCDF
  ABDFG
  ABDEFG
  ACF
  ABCDEFG
  ABCDFG
).map { |x| Set.new(x.chars) }.each_with_index.to_h.invert

APPEARANCE_COUNTS = Hash[('A'..'G').map { |l|
  [l, DIGIT_PATTERNS.count { |_, s| s.include? l }]
}]

p APPEARANCE_COUNTS

class Display < Struct.new(:samples, :output)
  def unknown_samples
    samples.find_all { |s| !@known_digits.include?(s) }
  end

  def find_obvious_digits!
    samples.each do |sample|
      if sample.obvious_digit
        @known_digits[sample] = sample.obvious_digit
      end
    end
  end

  def reduce_possible_segments!
    @known_digits.each do |digit, number|
      pattern = DIGIT_PATTERNS[number]
      pattern.each do |s|
        @possible_segments[s] = @possible_segments[s].intersection(digit.wires)
      end
    end
  end

  def check_appearance_counts!
    @possible_segments.each do |segment, wires|
      wires.filter! do |wire|
        samples.count { |s| s.wires.include? wire } == APPEARANCE_COUNTS[segment]
      end
    end
  end

  def find_only_possible_digits!
    unknown_samples.each do |sample|
      possible_digits = sample.possible_digits
      possible_digits.filter! do |digit|
        p sample
        p digit
        p DIGIT_PATTERNS[digit]
        p @possible_segments
        DIGIT_PATTERNS[digit].all? do |segment|
          !@possible_segments[segment].union(sample.wires).empty?
        end
      end
      @known_digits[sample] = possible_digits[0] if possible_digits.length == 1
    end
  end

  def check_known_segments!
    unknown_samples.each do |sample|
      wires = sample.wires
      known = Set.new(wires.map { |wire| @possible_segments.find { |x, y| y == Set[wire] } }.find_all { |x| x != nil }.map &:first)
      possible = sample.possible_digits.find_all { |number| known.subset? DIGIT_PATTERNS[number] }
      if possible.length == 1
        @known_digits[sample] = possible[0]
      end
    end
  end

  def done?
    @known_digits.length == 10
  end

  def analyze
    @known_digits = {}
    @possible_segments = Hash[('A'..'G').map { |d| [d, Set.new('a'..'g')] }]
    find_obvious_digits!
    reduce_possible_segments!
    check_appearance_counts!
    check_known_segments!
    reduce_possible_segments!
    if !done?
      puts "Not done!"
      p @possible_segments
      p @known_digits
      exit 1
    end
  end

  def value
    throw "not done!" unless done?
    output.map { |x| @known_digits[x].to_s }.join("").to_i
  end
end

class Digit < Struct.new(:wires)
  def possible_digits
    DIGIT_PATTERNS.find_all { |d, set| set.length == wires.length }.map { |d| d[0] }
  end
  def obvious_digit
    if possible_digits.length == 1
      possible_digits[0]
    end
  end
  def inspect
    "<#{wires.to_a.sort.join("")}>"
  end
end

displays = input.split("\n").map do |display|
  samples, output = display.split(" | ")
  samples = samples.split(" ").map { |digit| Digit.new(Set.new(digit.chars)) }
  output = output.split(" ").map { |digit| Digit.new(Set.new(digit.chars)) }
  Display.new(samples, output)
end

p (displays.map do |display|
  p display
  display.analyze
  p display.value
  display.value
end).sum
