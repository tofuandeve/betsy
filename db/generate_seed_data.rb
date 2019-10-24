require "faker"
require "date"
require "csv"

# we already provide a filled out media_seeds.csv file, but feel free to
# run this script in order to replace it and generate a new one
# run using the command:
# $ ruby db/generate_seeds.rb
# if satisfied with this new media_seeds.csv file, recreate the db with:
# $ rails db:reset
# doesn't currently check for if titles are unique against each other

CSV.open("db/merchant_seeds.csv", "w", :write_headers => true,
    :headers => ["username", "email"]) do |csv|
        25.times do
            username = Faker::Internet.username
            email = Faker::Internet.email
            
            csv << [username, email]
        end
    end