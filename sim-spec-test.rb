require './simul.rb'
#Run using "rspec sim-spec-test.rb"

#Tests building functionality
describe "building" do
	describe "create a building" do
		it "has 1 floor and 1 elevator by default" do
			building = Building.new
			building.number_of_elevators.should == 1
			building.number_of_floors.should == 1
		end
		it "has elevators if given elevators" do
			building = Building.new(:elevator_count => 3)
			building.number_of_elevators.should == 3
		end
		it "has floors if given floors" do
			building = Building.new(:floor_count => 3)
			building.number_of_floors.should == 3
		end
	end
end

#Tests floor functionality
describe "floor" do
	describe "create a floor" do
		it "has a capacity of 50 by default" do
			floor = Floor.new
			floor.capacity.should == 50
		end
		it "displays the right string representation" do
			floor = Floor.new
			floor.to_s.should == "|||Leaving: 0 Arrived: 0 |||"
		end
		it "has a capacity other than 50 if given one" do
			floor = Floor.new(:capacity => 96)
			floor.capacity.should == 96
		end
	end
	before(:each) do
		@a = Person.new(0)
		@b = Person.new(0)
	end
	it "adds a person" do
		floor = Floor.new
		floor.add_person(@a)
		floor.person_queue.should == [@a]
	end
	it "removes a person" do
		floor = Floor.new
		floor.add_person(@a)
		floor.add_person(@b)
		floor.remove_person(@a)
		floor.person_queue.should == [@b]
	end
end

#Tests elevator functionality
describe "elevator" do
	describe "create an elevator" do
		it "has a capacity of 15 by default" do
			elevator = Elevator.new
			elevator.capacity.should == 15
		end
		it "has a different capacity if given one" do
			elevator = Elevator.new(:capacity => 96)
			elevator.capacity.should == 96
		end
		it "has a status of stationary" do
			elevator = Elevator.new
			elevator.status.should == "stationary"
		end
		it "has a current floor of 0" do
			elevator = Elevator.new
			elevator.current_floor.should == 0
		end
	end
end

#Tests person functionality
describe "person" do
	describe "create a person" do
		it "has the correct destination" do
			person = Person.new(23)
			person.destination.should == 23
		end
	end
end