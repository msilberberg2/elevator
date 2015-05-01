require "./person.rb"
require "./location.rb"

#This class represents the elevators used in the simulation
class Elevator < Location
	def initialize(args={})
		args[:capacity] ||= 15
		args[:floors] ||= 1
		super(args)
		#The maximum amount of people on the elevator is 15 by default. It can be changed when the elevator is constructed
		
		@maximum_people = args[:capacity]

		#floors represent the number of floors the elevator is connected to. By default, this is assumed to be 1.
		@floors = args[:floors]

		#@buttons is an array of all the buttons for each of the different floors this elevator has access to. 
		#Each button is a boolean.
		#true means that the elevator needs to stop there, and false means that the elevator does not.
		@buttons = Array.new(@floors, false)

		#Elevator's starting floor is always the 0th floor.
		@current_floor = 0
		
		#@status represents the elevator's direction
		@status = "stationary"
	end

	#Resets the button for floor n. Occurs when the elevator arrives at that floor.
	def reset_button(floor)
		@buttons[floor] = false
	end

	#Pushes the button for floor n
	def push_button(floor)
		@buttons[floor] = true
	end

	def add_person(person)
		if capacity > @people.count
			@people.push(person)
			push_button(person.destination)
		end
		#The location will not let somebody on if it has reached capacity
	end

	#Determines the direction elevator is moving in: up, down, or stationary
	#The direction is represented by a returned string
	def status
		return @status
	end

	#Returns the current floor
	def current_floor
		@current_floor
	end

	def move_up
		@status = "up"
		@current_floor = @current_floor + 1
	end
	def move_down
		@status = "down"
		@current_floor = @current_floor - 1
	end

	#Elevator behavior algorithm
	def pass_time
		start_floor = @current_floor

		#Floors are represented by an array of their corresponding buttons. 
		#above_floors are all floors above the current floor
		#below_floors are all floors below
		above_floors = []
		below_floors = []
		if @current_floor < @floors - 1
			above_floors = @buttons[current_floor+1..@buttons.count]
		end
		if @current_floor > 0
			below_floors = @buttons[0..current_floor - 1]
		end

		
		#Logic for movement
		#Returns to bottom floor if there is nobody to pick up
		if @buttons.include?(true) == false
			if current_floor != 0
				self.move_down
			end
		#If there is nobody in the elevator and people on the floor, then it will go in the direction that the majority of those people are going
		elsif @people == 0 && current_floor.empty? == false
			if current_floor.going_down_count > current_floor.going_up_count 
				self.move_down
			else
				self.move_up
			end
		##Otherwise, movement is determined by whether buttons are pressed for the elevator	
		#The elevator will continue moving in its current direction as long as buttons are pressed for it in that direction
		elsif above_floors.include?(true) && (status == "up")
			self.move_up
		elsif below_floors.include?(true) && (status == "down")
			self.move_down
		#If a direction has not been determined based on previous if/else statements, the elevator goes in the direction of more pushed buttons
		else
			above_count = 0
			below_count = 0
			above_floors.each do |f|
				if f == true
					above_count = above_count + 1
				end
			end
			below_floors.each do |f|
				if f == true
					below_count = below_count + 1
				end
			end
			if above_count > below_count
				self.move_up
			else
				self.move_down
			end
		end

		#Determines the status of the elevator
		end_floor = @current_floor
		change_status(start_floor, end_floor)
	end

	#Determines whether the elevator's status changes,
	#based on the difference between its floor at the beginning and end of a tick
	def change_status(start_floor, end_floor)
		#Determines whether the elevator's status changes
		if end_floor > start_floor
			@status = "up"
		elsif end_floor < start_floor
			@status = "down"
		else end_floor < start_floor
			@status = "stationary"
		end
	end

	#Elev_People stands for number of people in elevator
	#Dir stands for direction
	def to_s
		":||Elev_People: #{person_count} Dir: #{status}||"
	end
end