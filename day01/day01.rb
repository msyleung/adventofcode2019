total_fuel = 0
part2 = true

# this func calculates fuel based off of formula given
# mass divided by 3, then subtract 2
def calc_fuel(num)
  (num.to_i / 3) - 2
end

# this func is designed to recursively calculate
# additional fuel required from adding fuel into the module
def calc_additonal(fuel)
  # add break condition (if fuel is less than 0)
  fuel <= 0 ? 0 : fuel + calc_additonal(calc_fuel(fuel))
end

arr = File.read('input')

arr.split("\n").each do |module_mass|
  fuel = calc_fuel(module_mass)
  fuel = calc_additonal(fuel) if part2
  total_fuel += fuel
end

puts total_fuel
# first_half
# 3232358

# second_half
# 4845669
