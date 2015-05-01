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

	#Returns the bottom floor
	def elev_resting_floor
		if @floors != nil
			return @floors[0]
		end
		puts "Error. There are no floors!"
	end

	#Defines building's behavior during one tick
	def pass_time
		#For each elevator
		@elevators.each do |elev|
			#Refreshes the buttons before every elevator moves, so that elevator's don't follow already answered calls
			refresh_buttons

			curr_floor_num = elev.current_floor
			curr_floor = floors[curr_floor_num]
			#building handles transfers of people from floors to elevators and vice versa

			#Check who on the elevator gets off on this stop.
			arrivers = []
			elev.person_queue.each do |elev_person|
				if elev_person.destination == curr_floor_num
					arrivers.push(elev_person)
				end 
			end

			#Once you have a list of people who are getting off, have those people get off
			arrivers.each do |elev_person|
				if elev_person.destination == curr_floor_num
					elev.remove_person(elev_person)
					curr_floor.arrive
				end 
			end

			#Determines which way the elevator is going, and depending on that, determines whether people trying to go up or down will get on the elevator
			#It then sets departures equal to that group of people
			if elev.status == "up" || curr_floor_num == 0
				departures = curr_floor.going_up
			elsif elev.status == "down" || curr_floor_num == number_of_floors - 1
				departures = curr_floor.going_down
			#If the elevator is stationary, it will take anybody 
			else
				departures = curr_floor.going_up.concat(curr_floor.going_down)
			end

			#Check who on the floor is going in the same direction. As many people as possible who are going in the same direction will get on the elevator
			loop do 
 				break if elev.capacity == elev.person_count || curr_floor.no_people?
 				if departures.count > 0
 					p = departures.pop
 					curr_floor.remove_person(p)
 				else
 					#If there is room on the elevator, somebody going the opposite direction will also be taken.
 					p = curr_floor.pop
 				end
 				elev.add_person(p)
			end 
			
			#Elevator moves
			elev.pass_time
		end
		refresh_buttons
	end

	#Refreshes the building's buttons after every tick
	def refresh_buttons
		@elevators.each do |elev|
			curr_floor_num = elev.current_floor
			curr_floor = floors[curr_floor_num]
			#Only resets the current floor if it appears that the elevator did not pick up the maximum number of people, since that indicates that there might still be
			#people waiting
			if elev.capacity > elev.person_count
				#Turns off the floor buttons for this floor
				if elev.status == "up"
					curr_floor.reset_button_up
				elsif elev.status == "down"
					curr_floor.reset_button_down
				elsif curr_floor.no_people?
					curr_floor.reset_button_up
					curr_floor.reset_button_down
				end
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