require 'benchmark'
require 'byebug'

puts Benchmark.realtime {
  lines = File.new("A-large-practice.in", "r").read.split("\n")

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

  cases.each_with_index do |_case, i|
    word_number_map = {}
    # get character possibilities
    character_possibilities = _case.scan(/(?<=\().*?(?=\))|\D/).map { |g| g.each_char.to_a }


    character_possibilities.each_with_index do |characters, index|
      characters.each do |character|

        if words = index_character_word_map[index][character]
          words.each do |word|
            word_number_map[word] = word_number_map[word].to_i + 1
          end
        else
          break
        end
      end
    end

    debugger

    count ||= word_number_map.values.count { |number| number == length_of_words  }

    puts "Case ##{i + 1}: #{count}"
  end
}


