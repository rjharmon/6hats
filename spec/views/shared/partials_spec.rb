require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "shared partials:" do
  describe "shared/_box.erb" do
	def partial( *args ) 
		assigns[:box_options] = @opts
		render :partial => 'shared/box', *args
		r = content_for( @opts[:location] )
	end
	before :each do
		@result = nil
		@opts = { :location => :right }
	end

	it "should croak if not given a location to put the box" do
		@opts[:location] = nil
		lambda { partial }.should raise_error( /location.*required/ )
	end
	it "should croak with a wrong image-tag specifier" do
		@opts[:image] = "foo"
		lambda { partial }.should raise_error( /:image.*hash of options/ )
	end

	describe " generate a box:" do
		it "should have a box-top" do
			partial.should have_tag( "div.box-top" ) 
		end
		it "should have a box-body" do
			partial.should have_tag( "div.box-body" )
		end
	end
	it "should include an image tag if :image is provided" do
		@opts[:image] = { :src => '/foo' }
		partial.should have_tag( "img[src=/foo]" )
	end

	it "should honor the :title option" do
		@opts[:title] = "MyTitle"
		partial.should have_tag( "h2", "MyTitle" )
	end
	it "should honor the :subtitle option" do
		@opts[:title] = "hi"  # needed for subtitle to work :/
		@opts[:subtitle] = "SubTitle"
		partial.should have_tag( "h3", "SubTitle" )
	end
	it "should honor the :title_class options" do
		@opts[:title] = 'foo'
		@opts[:title_class] = 'bar'
		partial.should have_tag( "h2.bar", "foo" )
	end
	it "should allow the content to be placed in arbitrary section names" do
		@opts[:location] = 'foo'   # put into and retrieve from this label
		@opts[:title] = "checkme"  # this content will appear if it was stored and retrieved properly
		partial.should have_tag("h2", "checkme" )
	end

  end
end