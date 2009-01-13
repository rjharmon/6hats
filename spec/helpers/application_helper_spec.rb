require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  
  describe "box-creation helper" do
  	it "should return good HTML for a box"
  	it "should support the use of an :image option"
  	it "should place the content in :location => :right by default"
  	it "should allow the content to be placed in arbitrary section names"
  end
  
  describe "menu-item creation helper" do 
	it "should return a menu item with a link"
	it "should highlight the shortcut key so the user knows to use it"
	describe "for the current item" do
		it "should be tagged as the current item"
	end
	describe "for a non-current item" do
		it "should not be tagged as the current item"
	end
  end  
end
