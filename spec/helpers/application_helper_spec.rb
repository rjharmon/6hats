require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ApplicationHelper

describe ApplicationHelper do
  
  describe "box-creation helper" do
  	it "should return good HTML for a box"
  	it "should support the use of an :image option"
  	it "should place the content in :location => :right by default"
  	it "should allow the content to be placed in arbitrary section names"
  end
  
  describe "menu_item" do

	it "should return a menu item with a link"
	it "should highlight the shortcut key so the user knows to use it"
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
	end
	describe "for a non-current item" do
		before :each do
			should_receive(:current_page?).and_return( false )
			@result = menu_item("a", "Apples", "/")
		end
		it "should show a link tag" do
			@result.should have_tag("a", "Apples")
		end
		it "should include an li" do
			@result.should have_tag("li")
		end
		it "should not be tagged as the current item" do
			@result.should_not have_tag("li.active")
		end
	end
  end  
end
