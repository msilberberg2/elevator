#A superclass designed to handle Floor and Elevator's mutual methods
class Location
	def initialize(args={})
		#@people contains all the Person objects in the location
		@people = []
		args[:capacity] ||= 0
		@maximum_people = args[:capacity]
	end

	#Returns the queue of people at the location
	def person_queue
		@people
	end

	#Returns the number of people on the floor
	def person_count
		@people.count
	end

	#Removes a person from person array
	def remove_person(person)
		@people.delete(person)
	end

	#returns the capacity of people in this location
	def capacity
		@maximum_people
	end
end