require 'set'

input = `pbpaste`

class Display < Struct.new(:samples, :output)
end

class Digit < Struct.new(:segments)
  UNIQUE_DIGITS = { 2 => 1, 4 => 4, 3 => 7, 7 => 8 }
  def obvious_digit
    UNIQUE_DIGITS[segments.length]
  end
end

displays = input.split("\n").map do |display|
  samples, output = display.split(" | ")
  samples = samples.split(" ").map { |digit| Digit.new(Set.new(digit.chars)) }
  output = output.split(" ").map { |digit| Digit.new(Set.new(digit.chars)) }
  Display.new(samples, output)
end

p displays.map(&:output).flatten.find_all { |digit| digit.obvious_digit != nil }.length
