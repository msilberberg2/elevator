#This class represents the people used in the simulation
class Person
	def initialize(destination)
		#destination is the intended floor of person, represented by that floor's number
		@destination = destination
	end

	def destination
		@destination
	end
end