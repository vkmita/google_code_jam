require 'benchmark'
require 'byebug'

puts Benchmark.realtime {
  input_file = File.new(ARGV[0], 'r')
  output_file = File.new(input_file.to_path.sub(/\.in\z/, '.out'), 'w')

  lines = input_file.read.split("\n")

  _ = lines.shift # number of cases

  output_text = ''

  lines.each_with_index do |_case, i|
    shyness_number = _case.sub(/\A\d+ /, '').each_char.map(&:to_i)

    total_number = 0
    additional_people = 0
    shyness_number.each_with_index do |number, index|
      if total_number < index
        additional_people += (index - total_number)
        total_number += (number + (index - total_number))
      else
        total_number += number
      end

    end

    output_text << "Case ##{i + 1}: #{additional_people}\n"
  end

  output_file.write(output_text)
  output_file.close
}