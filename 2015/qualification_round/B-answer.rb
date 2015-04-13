require 'benchmark'
require 'byebug'

puts Benchmark.realtime {
  input_file = File.new(ARGV[0], 'r')
  output_file = File.new(input_file.to_path.sub(/\.in\z/, '.out'), 'w')

  lines = input_file.read.split("\n")

  _ = lines.shift # number of cases

  output_text = ''

  i = 1

  while lines.any?
    _case = lines.shift(2)
    _ = _case.first # number of diners with non-empty plates
    turns = 0

    non_empty_plates = _case.last.scan(/\d+/).map(&:to_i)

    while non_empty_plates.any?

      max_index = non_empty_plates.each_with_index.max[1]
      max_pancakes = non_empty_plates[max_index]

      if (max_pancakes != 2) && (max_pancakes % 2 == 0)
        non_empty_plates[max_index] = (max_pancakes / 2)
        non_empty_plates << (max_pancakes / 2)
      else
        non_empty_plates.map! { |plate| plate == 1 ? nil : plate - 1 }.compact!
      end

      turns += 1
    end

    output_text << "Case ##{i}: #{turns}\n"

    i += 1
  end

  output_file.write(output_text)
  output_file.close
}