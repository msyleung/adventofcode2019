def set_program_alarm_1202(int_arr)
  #replace position 1 with the value 12
  int_arr[1] = 12
  # replace position 2 with the value 2
  int_arr[2] = 2
  return int_arr
end

def opcode_helper(intcode_program, index, opcode)
  # The three integers immediately after the opcode tell you these three positions
# the first two indicate the positions from which you should read the input   values
  first = intcode_program[index + 1]
  second = intcode_program[index + 2]
  # and the third indicates the position at which the output should be stored.
  location = intcode_program[index + 3]
  if intcode_program.size >= first || intcode_program.size >= second
    if opcode == 1
      # Opcode 1 adds together numbers read from two positions
      result = intcode_program[first] + intcode_program[second]
    elsif opcode == 2
      # Opcode 2 multiples them together
      result = intcode_program[first] * intcode_program[second]
    else
      raise "Unknown opcode"
    end
    # and stores the result in a third position.
    intcode_program[location] = result
  else
    # if the number is out of bounds, put error
    raise "Error"
  end
  return intcode_program
end

def intcode_reader(intcode_program)
  next_index = 0
  intcode_program.each.with_index do |intcode, index|
    next_index == 0 ? next_index : next_index -= 1
    next if next_index != 0
    if intcode == 99
      # 99 means that the program is finished and should immediately halt.
      break
    elsif intcode == 1 || intcode == 2
      intcode_program = opcode_helper(intcode_program, index, intcode)
      # move forward by stepping forward 4 positions.
      next_index = 4
    end
  end
  p intcode_program
end

# Testing the code because i wanted to and it's kinda a good idea
def test(int_arr, ans)
  my_ans = intcode_reader(int_arr)
  puts my_ans == ans ? "OK" : "Failed: answer is not #{ans}"
end

test([1,9,10,3,2,3,11,0,99,30,40,50], [3500,9,10,70,2,3,11,0,99,30,40,50])
test([1,0,0,0,99], [2,0,0,0,99])
test([2,3,0,3,99], [2,3,0,6,99])
test([2,4,4,5,99,0], [2,4,4,5,99,9801])
test([1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99])

# day02 ans:
intcode_reader(set_program_alarm_1202([1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,13,19,1,9,19,23,2,13,23,27,2,27,13,31,2,31,10,35,1,6,35,39,1,5,39,43,1,10,43,47,1,5,47,51,1,13,51,55,2,55,9,59,1,6,59,63,1,13,63,67,1,6,67,71,1,71,10,75,2,13,75,79,1,5,79,83,2,83,6,87,1,6,87,91,1,91,13,95,1,95,13,99,2,99,13,103,1,103,5,107,2,107,10,111,1,5,111,115,1,2,115,119,1,119,6,0,99,2,0,14,0]))

#[3790689, 12, 2, 2, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 1, 13, 60, 1, 9, 19, 63, 2, 13, 23, 315, 2, 27, 13, 1575, 2, 31, 10, 6300, 1, 6, 35, 6302, 1, 5, 39, 6303, 1, 10, 43, 6307, 1, 5, 47, 6308, 1, 13, 51, 6313, 2, 55, 9, 18939, 1, 6, 59, 18941, 1, 13, 63, 18946, 1, 6, 67, 18948, 1, 71, 10, 18952, 2, 13, 75, 94760, 1, 5, 79, 94761, 2, 83, 6, 189522, 1, 6, 87, 189524, 1, 91, 13, 189529, 1, 95, 13, 189534, 2, 99, 13, 947670, 1, 103, 5, 947671, 2, 107, 10, 3790684, 1, 5, 111, 3790685, 1, 2, 115, 3790687, 1, 119, 6, 0, 99, 2, 0, 14, 0]
