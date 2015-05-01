require './sim.rb'
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
	it "can return the resting floor" do
		building = Building.new(:floor_count => 3)
		building.elev_resting_floor.to_s.should == "floor 0"
	end
end

#Tests floor functionality
describe "floor" do
	describe "create a floor" do
		it "has a blank name, a capacity of 50, and no reachable elevators by default" do
			floor = Floor.new
			floor.number_of_elevators.should == 0
			floor.to_s.should == ""
			floor.capacity.should == 50
		end
		it "has a name if given a name" do
			floor = Floor.new(:name => "floor 72")
			floor.to_s.should == "floor 72"
		end
		it "has a number of reachable elevators if given a number of elevators" do
			floor = Floor.new(:elev_count => 13)
			floor.number_of_elevators.should == 13
		end
		it "has a capacity other than 50 if given one" do
			floor = Floor.new(:capacity => 96)
			floor.capacity.should == 96
		end
	end
	it "adds a person" do
		floor = Floor.new
		floor.add_person("Bill")
		floor.person_queue.should == ["Bill"]
	end
	it "removes a person" do
		floor = Floor.new
		floor.add_person("Bill")
		floor.add_person("Carl")
		floor.remove_person("Bill")
		floor.person_queue.should == ["Carl"]
	end
end

#Tests elevator functionality
describe "elevator" do
	describe "create an elevator" do
		it "has a capacity of 10 by default" do
			elevator = Elevator.new
			elevator.capacity.should == 10
		end
		it "has a different capacity if given one" do
			elevator = Elevator.new(:capacity => 96)
			elevator.capacity.should == 96
		end
		it "has a number of reachable elevators if given a number of elevators" do
			floor = Floor.new(:elev_count => 13)
			floor.number_of_elevators.should == 13
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