require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ApplicationHelper

describe ApplicationHelper do
  
  describe "box" do
	before :each do 
		@result = false
		@fake_block = lambda { @result = true }
	end
	
	it "should render the box layout, on the right by default" do
		should_receive( :render ).with( { :layout => "shared/box" } ).and_return( @fake_block.call )
		box do 
			# nothing particular - 
		end
		@result.should be_true
		@box_options[:location].should == :right
	end
	it "should pass options through to the partial" do
		should_receive( :render ).with( { :layout => "shared/box" } ).and_return( @fake_block.call )
		box :title => "hi", :location => :left do
			# not much
		end
		@box_options.should == { :title => 'hi', :location => :left }
	end
	it "should have a default location of :right" do
		should_receive( :render ).with( { :layout => "shared/box" } ).and_return( @fake_block.call )
		box do
			# not much
		end
	end
	
  end
  
  describe "menu_item" do

	describe "for the current item" do
		before :each do
			should_receive(:current_page?).and_return( true )
			@result = menu_item("a", "Apples", "/")
		end
		it "should have a link in there" do
			@result.should have_tag("li>a")
		end
		it "should be tagged as the current item" do
			@result.should have_tag("li.active", "Apples")
		end

		it "should have an accesskey specified" do
			@result.should have_tag("li>a[accesskey=a]")
		end
		it "should highlight the shortcut key" do
			@result.should have_tag("span.shortcut", "A")
		end
	end
	describe "for a non-current item" do
		before :each do
			should_receive(:current_page?).and_return( false )
			@result = menu_item("a", "Apples", "/")
		end
		it "should include an li" do
			@result.should have_tag("li")
		end
		it "should show a link tag" do
			@result.should have_tag("a", "Apples")
		end
		it "should not be tagged as the current item" do
			@result.should_not have_tag("li.active")
		end
		it "should have an accesskey specified" do
			@result.should have_tag("li>a[accesskey=a]")
		end
		it "should highlight the shortcut key" do
			@result.should have_tag("span.shortcut", "A")
			puts @result
		end
	end
  end  
end
