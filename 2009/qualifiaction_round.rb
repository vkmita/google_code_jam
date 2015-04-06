require 'benchmark'
require 'byebug'

puts Benchmark.realtime {
  input_file = File.new(ARGV[0], 'r')
  output_file = File.new(input_file.to_path.sub(/\.in\z/, '.out'), 'w')

  lines = input_file.read.split("\n")

  length_of_words, number_of_words, number_of_cases = lines.shift.split(' ').map(&:to_i)

  words = lines.shift(number_of_words)
  cases = lines.shift(number_of_cases)

  index_character_word_map = {}
  words.each do |word|
    word.each_char.each_with_index do |character, index|
      index_character_word_map[index] ||= {}
      index_character_word_map[index][character] ||= []
      index_character_word_map[index][character] << word
    end
  end

  output_text = ''

  cases.each_with_index do |_case, i|
    word_number_map = {}
    # get character possibilities
    character_possibilities = _case.scan(/(?<=\().*?(?=\))|[^\(\)]/).map { |g| g.each_char.to_a }
    count = 0
    done = nil
    character_possibilities.each_with_index do |characters, index|
      break if done
      characters.each do |character|
        if words = index_character_word_map[index][character]
          words.each do |word|
            if (current_count = (word_number_map[word] || 0) + 1) != length_of_words
              word_number_map[word] = current_count
            else
              count += 1
            end
          end
        else
          done = 0
          break
        end
      end
    end

    output_text << "Case ##{i + 1}: #{done || count}\n"
  end

  output_file.write(output_text)
  output_file.close
}




