#Each floor has a button pair for every elevator.
#Each button pair tracks two booleans, one for up and one for down.
#Whenever either boolean is true, somebody wants to go in that direction.
class FloorButton
	def initialize
		@up = false
		@down = false
	end

	#When somebody wants to go to a floor, the button for that floor's direction is turned on.
	def go_up
		@up = true
	end
	def go_down
		@down = true
	end

	#When people depart on an elevator, the button for that elevator's direction is reset.
	def no_up
		@up = false
	end
	def no_down
		@down = false
	end

	#These methods report button status: Whether they have been pressed or not
	def up_pressed?
		@up
	end
	def down_pressed?
		@down
	end

	def to_s
		"Up? #{up_pressed?}. Down? #{down_pressed?}."
	end
end