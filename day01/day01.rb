total_fuel = 0

arr = File.read('input')

arr.split("\n").each do |module_mass|
  fuel = (module_mass.to_i / 3) - 2
  total_fuel += fuel
end

puts total_fuel
# 3232358
