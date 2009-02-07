		Factory.sequence :name do |n|
			"Joe Gunchi #{n}"
		end
		Factory.sequence :login do |n|
			"login#{n}"
		end
		Factory.sequence :email do |n|
			"person#{n}@example.com" 
		end
		Factory.sequence :generated_string do |n|
#			require 'digest/sha1'
#			sha1 = Digest::SHA1.hexdigest("#{n}")
			"generated string # #{n}"
		end
		  
		Factory.define :user do |u|
			u.login { |l| Factory.next :login }
			u.name { |n| Factory.next :name }
			u.email { |e| Factory.next :email }
			u.password { |e| "password" }
			u.password_confirmation { |e| "password" }
			
			u.state 'active'
		end
		Factory.define :topic do |t|
			t.name { |n| Factory.next :generated_string }
			t.summary { |s| Factory.next :generated_string }
			t.user { |u| u.association( :user ) }
		end

    Factory.define :thought do |t|
      t.summary { |s| Factory.next :generated_string }
      t.detail { |d| Factory.next :generated_string }
      t.topic { |t| t.association( :topic ) }
    end
    