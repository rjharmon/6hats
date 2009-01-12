describe "Relationships", :shared => true do    
	def self.it_has_one(model, relation, output=nil)
		it "#{output}" do
			model << relation
			model.should_not be_empty
		end
	end
	def self.it_has_more(model, relation, output=nil)
		it "#{output}" do
			model << relation
			model << relation
			model.size.should == 2
		end
	end
end

