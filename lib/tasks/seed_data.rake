namespace :db do
  desc "Load seed data (from db/seed_data) into the current environment's database." 
  task :seed => :environment do
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/seed_data/*.yml').each do |file|
      Fixtures.create_fixtures('db/seed_data', File.basename(file, '.*'))
    end
  end
end
