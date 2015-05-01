require './floor.rb'
require './elevator.rb'

#A building contains a number of elevators and a number of floors
class Building
	#Construct the initial building object
	def initialize(args={})
		#The floors and elevators of the building are contained in arrays
		#The object takes an a number of floors and an array of elevator objects as input. If it is given none, it assumes
		#that there are 1 floor and 1 elevator.
		#The lowest floor is @floors[0], and each subsequent floor is above the last one
		args[:floor_count] ||= 1
		args[:elevator_count] ||= 1
		args[:person_hash] ||= Hash.new

		floor_count = args[:floor_count]

		#Uses @elevator_count to construct an array of elevators.
		@elevator_count = args[:elevator_count]
		@elevators = []
		@elevator_count.times do |e|
			@elevators.push(Elevator.new(:floors => floor_count))
		end

		#Uses floor_count to construct an array of floors
		#Floors are ordered from 0 to n
		@floors = []
		floor_range = (1..floor_count)
		floor_range.each do |floor|
			@floors.push(Floor.new(:floor_num => floor-1))
		end

		#people is a hash of Person object keys. If the value is an integer n, the person is placed on the nth floor
		people = args[:person_hash]
		place_all(people)

		
	end

	#people is a hash of Person object keys. If the value is an integer n, the person is placed on the nth floor
	#If the value is a string "n," the person is placed on the nth elevator.
	def place_all(people)
		people.each_key do |person| 
			start = people[person]
			start_floor = @floors[start]
			start_floor.add_person(person)
			#Accounts for the case where the person starts on the floor they want to go to
			if start == person.destination
				start_floor.arrive
				start_floor.remove_person(person)
			end
		end
	end

	def floors
		@floors
	end
	def elevators
		@elevators
	end

	#Returns the number of elevators in the building
	def number_of_elevators
		@elevators.count
	end

	#Returns the number of floors in the building
	def number_of_floors
		@floors.count
	end

	#Defines building's behavior during one tick
	def pass_time
		#For each elevator
		@elevators.each do |elev|
			refresh_buttons

			curr_floor_num = elev.current_floor
			curr_floor = floors[curr_floor_num]
			#building handles transfers of people from floors to elevators and vice versa

			#Number of people debarking
			num_debarking = elev.debark
			#For each person that debarks, one person arrive on the floor
			num_debarking.times do
				curr_floor.arrive
			end

			
			#Determines whether people trying to go up or down will get on the elevator
			#It then sets departures equal to that group of people
			departures = prepare_departure(elev,curr_floor)
			
			#Check who on the floor is going in the same direction. As many people as possible who are going in the same direction will get on the elevator
			loop do 
 				break if elev.capacity == elev.person_count || departures.count == 0
 				p = departures.pop
 				curr_floor.remove_person(p)
 				elev.add_person(p)
			end 
			
			#Elevator moves
			elev.pass_time
		end
		refresh_buttons
	end

	#Determines whether people trying to go up or down will get on the elevator
	#It then sets departures equal to that group of people
	def prepare_departure(elev, curr_floor)
		up_people = curr_floor.going_up
		down_people = curr_floor.going_down
		#If an elevator has nobody in it and is on a floor with people, it will try to take as many people as possible in the direction they want
		if elev.no_people? && !curr_floor.no_people?
			if up_people.count > down_people.count
				elev.set_status("up")
			else
				elev.set_status("down")
			end
		end
		#It then takes whoever is going in the same direction as it
		if elev.status == "down" || curr_floor.number == @floors.count - 1
			departures = down_people
		else
			departures = up_people
		end
		return departures
	end

	#Refreshes the building's buttons after every tick
	def refresh_buttons
		@elevators.each do |elev|
			curr_floor_num = elev.current_floor
			curr_floor = @floors[curr_floor_num]
			#Only resets the current floor if it appears that the elevator did not pick up the maximum number of people, since that indicates that there are not
			#people waiting
			if elev.capacity > elev.person_count
				#Turns off the floor buttons for this floor
				if elev.status == "up"
					curr_floor.reset_button_up
				elsif elev.status == "down"
					curr_floor.reset_button_down
				end
			end
			if curr_floor.no_people?
				curr_floor.reset_button_up
				curr_floor.reset_button_down
			end

			#Turns off the elevator button for this floor
			elev.reset_button(curr_floor_num)
			#Turns on the floor buttons for all floors with people still waiting.
			@floors.each do |floor|
				if floor.up_button_status || floor.down_button_status
					elev.push_button(floor.number)
				end
			end
		end
	end

	#The building string representation consists of a stack of floors, with elevators on that floor on the right
	def to_s	
		#The key is the floor number, the value is the string representation of all the elevators on that floor
		elevator_strings = Hash.new
		floor_string = "____________________________\n|Building Co. Building (TM)|"
		@elevators.each do |e|
			#If an elevator is already on that floor, the elevator's string is added to the right of the other elevator. 
			#Otherwise, it becomes the elevator string for that floor
			if elevator_strings[e.current_floor] == nil
				elevator_strings[e.current_floor] = e.to_s
			else
				elevator_strings[e.current_floor] = elevator_strings[e.current_floor] + e.to_s
			end
		end
		#The floors are stacked below each other in reverse. If elevator(s) are on the floor, they are appended on the right.
		floor_count = @floors.count - 1
		@floors.reverse.each do |f|
			curr_floor_elevators = elevator_strings[floor_count]
			if curr_floor_elevators == nil
				curr_floor_elevators = ""
			end
			floor_string = floor_string + "\n" + f.to_s + curr_floor_elevators 
			floor_count = floor_count - 1
		end
		return floor_string
	end
end