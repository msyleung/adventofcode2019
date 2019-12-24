class Intcode

  def set_memory(values)
    values.each.with_index do |value, index|
      @memory[index] = value
    end
    @memory
  end

  # turns Intcode values into a Hash w/ @memory[0] = first_value
  def initialize(values)
    @values = values
    @memory = Array.new()
    set_memory(@values)
  end

  def reset_memory
    @memory = Array.new()
    set_memory(@values)
  end

  # this func replaces the value at address 1 to 12
  # replace value at address 2 with the num 2
  # each of the two input values will be between 0..99
  def set_program_alarm(noun = 12, verb = 2)
    @memory[1] = noun
    @memory[2] = verb
    return @memory
  end

  # brute force solution for part 2
  def brute_force_calc_gravity_assist(goal = 19690720)
    new_verb = -1
    while (new_verb <= 100 && (addr0 = @memory[0]) != goal)
      new_verb += 1 #must be between 0 .. 99
      new_noun = 0
      while (new_noun <= 100)
        #must also be between 0 .. 99
        puts "noun: #{new_noun}, verb: #{new_verb}"
        set_program_alarm(new_noun, new_verb)
        intcode_reader()
        break if (addr0 = @memory[0]) == goal
        puts "at #{addr0} : #{addr0 - 19690720} from goal: 19690720"
        new_noun += 1
        # reset the memory somehow
        reset_memory
      end
    end
    return new_noun, new_verb
  end

  # faster solution for part 2, but could do better
  # say if diff is greater than 100, new_noun + 10
  # want diff = 0
  def faster_calc_gravity_assist(goal = 19690720, new_noun = 50, new_verb = 50)
    set_program_alarm(new_noun, new_verb)
    intcode_reader()
    if (addr0 = @memory[0]) == goal
      return new_noun, new_verb
    else
      reset_memory
      # puts "diff: #{addr0 - goal} @ #{new_noun}, #{new_verb}"
      if (diff = addr0 - goal) < -100 and (new_noun + 1) <= 99
        faster_calc_gravity_assist(goal, new_noun + 1, new_verb)
      elsif diff > 100 and (new_noun - 1) >= 0
        faster_calc_gravity_assist(goal, new_noun - 1, new_verb)
      elsif diff > 100 and (new_verb + 1) <= 99
        faster_calc_gravity_assist(goal, new_noun, new_verb + 1)
      elsif diff <= 100 and (new_verb - 1) >= 0
        faster_calc_gravity_assist(goal, new_noun, new_verb - 1)
      end
    end
  end

  # The three integers immediately after the opcode tell you these three positions
  # the first two indicate the positions from which you should read the input values
  # and the third indicates the position at which the output should be stored.
  def opcode_helper(index, opcode)
    first = @memory[index + 1]
    second = @memory[index + 2]
    location = @memory[index + 3]
    if @memory.size >= first && @memory.size >= second
      if opcode == 1 #adds params
        result = @memory[first] + @memory[second]
      elsif opcode == 2 #multiplies params
        result = @memory[first] * @memory[second]
      else
        raise "Unknown opcode"
      end
      @memory[location] = result
    else # if the number is out of bounds, put error
      raise "Error: memsize = #{@memory.size}, #{first} #{second}"
    end
    return @memory
  end

  def intcode_reader
    next_instruction = 0
    @memory.each.with_index do |opcode, instruction_pointer|
      next_instruction == 0 ? next_instruction : next_instruction -= 1
      next if next_instruction != 0
      case opcode
      when 99 # program is finished; halt immediately
        break
      when 1..2
        @memory = opcode_helper(instruction_pointer, opcode)
        # move forward by stepping forward 4 positions.
        next_instruction = 4
      end
    end
    @memory
  end

end

# Testing the code because i wanted to and it's kinda a good idea
def first_half_test(int_arr, ans)
  arr = Intcode.new(int_arr)
  my_ans = arr.intcode_reader
  puts my_ans == ans ? "OK" : "Failed: answer is not #{ans}"
end

# first_half_test([1,9,10,3,2,3,11,0,99,30,40,50], [3500,9,10,70,2,3,11,0,99,30,40,50])
# first_half_test([1,0,0,0,99], [2,0,0,0,99])
# first_half_test([2,3,0,3,99], [2,3,0,6,99])
# first_half_test([2,4,4,5,99,0], [2,4,4,5,99,9801])
# first_half_test([1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99])

blep = Intcode.new([1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,13,19,1,9,19,23,2,13,23,27,2,27,13,31,2,31,10,35,1,6,35,39,1,5,39,43,1,10,43,47,1,5,47,51,1,13,51,55,2,55,9,59,1,6,59,63,1,13,63,67,1,6,67,71,1,71,10,75,2,13,75,79,1,5,79,83,2,83,6,87,1,6,87,91,1,91,13,95,1,95,13,99,2,99,13,103,1,103,5,107,2,107,10,111,1,5,111,115,1,2,115,119,1,119,6,0,99,2,0,14,0])
blep.set_program_alarm
puts "first half: #{blep.intcode_reader.first}" #3790689
# part 2
noun, verb =  blep.faster_calc_gravity_assist
puts "second half: #{100 * noun + verb}" #6533
