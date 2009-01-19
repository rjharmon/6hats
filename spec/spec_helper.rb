# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

# TODO: verify that this works
include AuthenticatedSystem
include AuthenticatedTestHelper

def content_for(name)
	t = response.template.instance_variable_get("@content_for_#{name}")
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end

module Spec
  module Rails
    module Matchers
      class MatchXpath  #:nodoc:
        
        def initialize(xpath)
          @xpath = xpath
        end

        def matches?(response)
          @response_text = response.body
          doc = REXML::Document.new @response_text
          match = REXML::XPath.match(doc, @xpath)
          not match.empty?
        end

        def failure_message
          "Did not find expected xpath #{@xpath}\n" + 
          "Response text was #{@response_text}"
        end

        def description
          "match the xpath expression #{@xpath}"
        end
      end

      def match_xpath(xpath)
        MatchXpath.new(xpath)
      end
    end
  end
end

# TODO: test whether stub_association! has any value

module Spec::Mocks::Methods
  def stub_association!(association_name, methods_to_be_stubbed ={})
    mock_assn = Spec::Mocks::Mock.new(association_name.to_s)
    stub_association_with(association_name, mock_assn, methods_to_be_stubbed)
  end

  def stub_association_with(association_name, values, methods_to_be_stubbed = {})
    methods_to_be_stubbed.each do |meth, return_value|
        values.stub!(meth).and_return(return_value)
    end
    yield(values) if block_given?

    self.stub!(association_name).and_return(values)
  end
end

module ViewExamples
	module ExampleMethods
	end
	module ExampleGroupMethods
		describe "a view", :shared => true do
			it "should have a title" do
				do_action
				assigns[:title].should_not be_blank
			end
		end
		describe "a form", :shared => true do
			it "should have a nice submit button" do
				( action, object ) = do_action
				label = action == 'new' ? "Create" : "Save"
				response.should have_tag("form[method=post][class='#{action}_#{object}']" ) do 
					with_tag("input[type='submit'][class='button'][value='#{label}']" )
				end
			end

			it "should have a nice cancel button" do
				( action, object ) = do_action
				label = action == 'new' ? "Create" : "Save"
				response.should have_tag("form[method=post][class=#{action}_#{object}]" ) do
					with_tag("a[class=cancel-button]", "Cancel" )
				end
			end
		end
	end
	def self.included(receiver)
	    	receiver.extend         ExampleGroupMethods
		receiver.send :include, ExampleMethods
	end
end


Spec::Runner.configure do |config|
  config.include(ViewExamples, :type => :view)
end

	
