require "./floorbutton.rb"
require "./location.rb"
require "./person.rb"

#Floors for the simulation
class Floor < Location
	#Constructor
	def initialize(args={})
		args[:floor_num] ||= 0
		args[:capacity] ||= 50
		super(args)
		#Represents the number floor this is
		@floor_num = args[:floor_num] 

		#@buttons represents the button pair used to call elevators. There is one for each floor
		@buttons = FloorButton.new

		#The maximum amount of people on the floor is 50 by default. It can be changed when the floor is constructed
		@maximum_people = args[:capacity]


		#arrived_count determines how many people have successfully arrived on this floor.
		@arrived_count = 0
	end

	#Removes the first person in the array of people on the floor
	def pop
		@people.pop
	end

	#Returns an array of all people going up
	def going_up
		up_people = []
		@people.each do |person|
			if person.destination > number
				up_people.push(person)
			end
		end
		return up_people
	end

	def going_up_count
		going_up.count
	end

	#Returns an array of all people going down
	def going_down
		down_people = []
		@people.each do |person|
			if person.destination < number
				down_people.push(person)
			end
		end
		return down_people
	end

	def going_down_count
		going_down.count
	end

	#Returns a boolean representing whether there are people on this floor
	def no_people?
		if person_queue.count == 0
			return true
		end
		false
	end

	def up_button_status
		return @buttons.up_pressed?
	end
	def down_button_status
		return @buttons.down_pressed?
	end

	#Pushes the up button given for an elevator, given that elevator's number
	def push_button_up
		@buttons.go_up
	end
	#Pushes the up button given for an elevator, given that number elevator
	def push_button_down
		@buttons.go_down
	end

	#Resets an elevator button if nobody wants to use that elevator
	def reset_button_up
		@buttons.no_up
	end
	def reset_button_down
		@buttons.no_down
	end

	#Adds a person to the person array
	def add_person(person)
		if capacity > @people.count
			@people.push(person)
			if number > person.destination
				push_button_down
			elsif number < person.destination
				push_button_up
			end
		end
		#The location will not let somebody on if it has reached capacity
	end

	#returns this floor's floor number
	def number
		@floor_num
	end
	#A person has arrived, so the floor's counter for number of arrived people increments.
	def arrive
		@arrived_count = @arrived_count + 1
	end

	def to_s
		"|||Leaving: #{person_queue.count} Arrived: #{@arrived_count} |||"
	end
end