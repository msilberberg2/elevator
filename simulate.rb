require './building.rb'

#Controls the simulation
#Note that my version of the simulate class supports multiple buildings
class Simulate
	def initialize
		#Registered contains all the registered objects in the simulation
		@registered = Array.new
	end

	#Causes one "tick" to execute
	#Then displays a string representation of the simulation
	def clock_tick
		@registered.each do |object|
			object.pass_time()
			puts to_s
			sleep(2)
		end
	end

	#Registers an object in the simulation
	def register(object)
		@registered.push(object)
	end

	#Runs the simulation for an inputted number of ticks
	def run(ticks)
		puts to_s
		sleep(2)
		ticks.times do
			clock_tick
		end
	end

	def to_s
		string = "\n================================================\n"
		string = string + "        Elevator Simulation: Next Step\n"
		string = string + "================================================"
		@registered.each do |object|
			string = string + "\n" + object.to_s + "\n"
		end
		return string
	end
end