# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

sources = {
  "Co_Berlin" => ["https://www.co-berlin.org/en/calender", 
                  "https://www.co-berlin.org"],
  "Berghain" => ["https://www.berghain.berlin/en/program/",
                  "https://berghain.de"],
}

sources.each do |title, urls|
  WebSource.create!(
    title: title,
    url: urls[0],
    base_url: urls[1]
  )
end

p("#{sources.length} web sources created")
