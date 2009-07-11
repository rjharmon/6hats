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
    Factory.sequence :token do |n|
      Digest::SHA1.hexdigest("#{n}")
    end
    Factory.sequence :generated_string do |n|
#     require 'digest/sha1'
#     sha1 = Digest::SHA1.hexdigest("#{n}")
      "generated string # #{n}"
    end

    Factory.define(:user) do |u|
      u.login                   { |u| Factory.next :login }
      u.name                    { |u| u.login || Faker::Name.name }
      u.email                   { Faker::Internet.email }
      u.password                { 'fake passwd' }
      u.password_confirmation   { 'fake passwd' }
      u.persistence_token       { Factory.next :token }
      u.single_access_token     { Factory.next :token }

      u.activated_at Time.now
    end
    
    
    Factory.define :topic do |t|
      t.name                    { |t| Factory.next :generated_string }
      t.summary                 { |t| Factory.next :generated_string }
      t.user                    { |t| t.association( :user ) }
    end

    Factory.define :thought do |t|
      t.summary                 { |th| Factory.next :generated_string }
      t.detail                  { |th| Factory.next :generated_string }
      t.topic                   { |th| th.association( :topic ) }
    end
    
    
    