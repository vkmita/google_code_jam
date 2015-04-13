require 'benchmark'
require 'byebug'

puts Benchmark.realtime {
  input_file = File.new(ARGV[0], 'r')
  output_file = File.new(input_file.to_path.sub(/\.in\z/, '.out'), 'w')

  lines = input_file.read.split("\n")

  _ = lines.shift # number of cases

  output_text = ''

  multiplication_map = {
    '1' => {
      '1' => '1',
      'i' => 'i',
      'j' => 'j',
      'k' => 'k'
    },
    'i' => {
      '1' => 'i',
      'i' => '-1',
      'j' => 'k',
      'k' => '-j'
    },
    'j' => {
      '1' => 'j',
      'i' => '-k',
      'j' => '-1',
      'k' => 'i'
    },
    'k' => {
      '1' => 'k',
      'i' => 'j',
      'j' => '-i',
      'k' => '-1'
    }
  }

  i = 1
  while lines.any?
    puts "case ##{i}"

    negative = false
    solved = false
    _case = lines.shift(2)
    characters = _case.last
    characters_length, repetitions = _case.first.split(' ').map(&:to_i) # number of diners with non-empty plates
    string = characters * repetitions


    i_is_possible = false
    j_is_possible = false
    k_is_possible = false


    i_first_char = string[0]
    i_index = 0

    test = characters * 5
    i_test_negative = false
    is_possible = false


    if characters_length < 100
      test[1..-1].each_char.each_with_object(i_first_char.dup) do |i_test_char, i_test_agg|
        i_test_negative = i_test_negative ^ !!i_test_agg.sub!(/\A\-/, '')
        if i_test_agg == 'i'
          i_is_possible = is_possible = true
          break
        end
        i_test_agg.replace(multiplication_map[i_test_agg][i_test_char])
      end
    else
      is_possible = true
    end


    if is_possible
      string[1..-1].each_char.each_with_object(i_first_char) do |i_char, i_agg|
        break if solved || !is_possible
        negative = negative ^ !!i_agg.sub!(/\A\-/, '')
        if i_agg == 'i'
          j_index = i_index + 1
          break unless (j_first_char = string[j_index]) && string[i_index + 2]

          if characters_length < 100
            if !j_is_possible
              is_possible = false
              j_test_negative = false
              j_start_index = j_index % characters_length

              test[(j_start_index + 1)..-1].each_char.each_with_object(j_first_char.dup) do |j_test_char, j_test_agg|
                j_test_negative = j_test_negative ^ !!j_test_agg.sub!(/\A\-/, '')
                if j_test_agg == 'j'
                  j_is_possible = is_possible = true
                  break
                end
                j_test_agg.replace(multiplication_map[j_test_agg][j_test_char])
              end
            end

          end


          string[j_index + 1..-1].each_char.each_with_object(j_first_char) do |j_char, j_agg|
            break if solved || !is_possible
            negative = negative ^ !!j_agg.sub!(/\A\-/, '')
            if j_agg == 'j'
              k_index = j_index + 1
              break unless k_first_char = string[k_index]

              if k_first_char == 'k' && !negative && (k_index + 1) == string.size
                solved = true
                break
              else
                break unless string[j_index + 2]


                if characters_length < 100
                  if !k_is_possible
                    is_possible = false
                    k_test_negative = false
                    k_start_index = k_index % characters_length

                    test[(k_start_index + 1)..-1].each_char.each_with_object(k_first_char.dup) do |k_test_char, k_test_agg|
                      k_test_negative = k_test_negative ^ !!k_test_agg.sub!(/\A\-/, '')
                      if k_test_agg == 'k'
                        k_is_possible = is_possible = true
                        break
                      end
                      k_test_agg.replace(multiplication_map[k_test_agg][k_test_char])
                    end
                  end
                end

                string[k_index + 1..-1].each_char.each_with_object(k_first_char) do |k_char, k_agg|
                  break if solved || !is_possible
                  k_agg.replace(multiplication_map[k_agg][k_char])
                  negative = negative ^ !!k_agg.sub!(/\A\-/, '')
                  k_index += 1
                  if k_agg == 'k' && !negative && (k_index + 1) == string.size
                    solved = true
                    break
                  end
                end
              end
            end
            j_index += 1
            j_agg.replace(multiplication_map[j_agg][j_char])
          end
        end
        i_index += 1
        i_agg.replace(multiplication_map[i_agg][i_char])
      end
    end


    output_text << "Case ##{i}: #{solved ? 'YES' : 'NO'}\n"

    i += 1
  end

  output_file.write(output_text)
  output_file.close
}