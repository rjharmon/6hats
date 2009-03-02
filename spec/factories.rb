require 'faker'

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
#     require 'digest/sha1'
#     sha1 = Digest::SHA1.hexdigest("#{n}")
      "generated string # #{n}"
    end
          
    Factory.define(:user) do |u|
      #  name                      :string(100)     default("")
      u.name {|u| u.login || Faker::Name.name }
      #  login                     :string(40)
      u.login { |u| u.name.gsub(/\W/,"").downcase.split(/ /).join(""); }

      #  email                     :string(100)
      u.email { Faker::Internet.email }
      #  crypted_password          :string(40)
      u.password { 'fake passwd' }
      u.password_confirmation { 'fake passwd' }
      #  state                     :string(255)     default("passive")
      u.state 'active'
      u.activated_at Time.now
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
    
    
    