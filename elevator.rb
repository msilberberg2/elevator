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
		@current_floor = @current_floor + 1
	end
	def move_down
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

		#The elevator move
		move(above_floors, below_floors)

		#Determines the status of the elevator
		end_floor = @current_floor
		change_status(start_floor, end_floor)
	end

	#logic for movement. Determines how the elevators move
	def move(above_floors, below_floors)
		#If there's nobody to pick up, it will return to the bottom
		if current_floor != 0 && !above_floors.include?(true) && !below_floors.include?(true) && person_queue == []
			self.move_down
		#Normally, it will go in the direction determined by its status. If stationary, movement is determined by whether buttons are pressed for the elevator	
		elsif status == "up" && current_floor < @floors - 1
			self.move_up
		elsif status == "down" && current_floor > 0
			self.move_down
		elsif above_floors.include?(true)
			self.move_up
		elsif below_floors.include?(true)
			self.move_down
		end
		#Returns to bottom floor if there is nobody to pick up
	end

	#People who have reached their destination debark from the elevator
	#Returns the number of people debarking
	def debark
		#Check who on the elevator gets off on this stop.
		arrivers = []
		person_queue.each do |elev_person|
			if elev_person.destination == current_floor
				arrivers.push(elev_person)
			end 
		end
		#Once you have a list of people who are getting off, have those people get off
		arrivers.each do |elev_person|
			if elev_person.destination == current_floor
				remove_person(elev_person)
			end 
		end
		return arrivers.count
	end
		

	#Determines whether the elevator's status changes,
	#based on the difference between its floor at the beginning and end of a tick
	def change_status(start_floor, end_floor)
		#Determines whether the elevator's status changes
		if end_floor > start_floor
			set_status("up")
		elsif end_floor < start_floor
			set_status("down")
		else end_floor < start_floor
			set_status("stationary")
		end
	end

	#Sets @status
	def set_status(stat)
		@status = stat
	end

	#Elev_People stands for number of people in elevator
	#Dir stands for direction
	def to_s
		":||Elev_People: #{person_count} Dir: #{status}||"
	end
end