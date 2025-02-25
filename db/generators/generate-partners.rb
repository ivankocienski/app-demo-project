require 'faker'
# require_relative '../config/environment'
# require 'active_support'
require "active_support/core_ext/integer/time"

25.times do |n|
  data = [
    Faker::Company.name, # name
    Faker::Lorem.sentence, # summary
    Faker::Lorem.paragraphs.join("\n"), # description 
    Faker::Time.between(from: DateTime.now - 5.years, to: DateTime.now), # created_at 
    Faker::Internet.email, # contact_email 
  ]

  puts <<-SQL
  INSERT INTO partners 
    (name, summary, description, created_at, contact_email)
    VALUES
    (#{data.map { |datum| %Q{'#{datum}'} }.join(", ")});


  SQL
  
end
