require './simulate.rb'

#Prompts for input for the simulation
print "Number of floors:"
floors = gets.to_i

print "Number of elevators:"
elevators = gets.to_i

print "Length of Simulation (In Ticks):"
time = gets.to_i

puts "Choose a Simulation (Input the corresponding number): "
puts "(1) This simulation places 5 people on the bottom floor who wants to get to the top floor."
puts "(2) This simulation places 10 people on each floor . Half want to get to the bottom floor, and the other half want to get to the top."
print "(3) This simulation populates the building with a group of people with random starting points and destinations"

sim_num = gets.to_i

person_hash = {}
if sim_num == 1
	person_hash = {Person.new(floors-1) => 0, Person.new(floors-1) => 0, Person.new(floors-1) => 0, Person.new(floors-1) => 0, Person.new(floors-1) => 0}
elsif sim_num == 2
	floors.times do |floor|
		person_hash = person_hash.merge({Person.new(floors-1) => floor, Person.new(floors-1) => floor, 
			Person.new(0) => floor, Person.new(floors-1) => floor, 
			Person.new(0) => floor, Person.new(floors-1) => floor, 
			Person.new(0) => floor, Person.new(floors-1) => floor, 
			Person.new(0) => floor, Person.new(floors-1) => floor})
	end
elsif sim_num == 3
	60.times do
		floor1 = rand(0..floors-1)
		floor2 = rand(0..floors-1)
		p = Person.new(floor1)
		person_hash[p] = floor2
	end
end

sleep(1)

#Creates a building
#Creates a simulate object and registers the building with it
#Has the simulation run for the specified number of ticks
building = Building.new({:floor_count => floors, :elevator_count => elevators, :person_hash => person_hash})
sim = Simulate.new
sim.register(building)
sim.run(time)