require 'json'
require 'open-uri'

puts 'cleaning the database'
Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

# Limited to letters a - t. Free API doesn't allow full use of there database.
letters_of_the_alphabet = ('a'..'t').to_a

letters_of_the_alphabet.each do |letter|
  puts "Adding all cocktails and ingredients that start with #{letter.upcase}"
  url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"
  drinks_serialized = open(url).read
  json_file = JSON.parse(drinks_serialized)

  json_file['drinks'].each do |drink|
    cocktail = Cocktail.new(name: drink['strDrink'])
    cocktail.valid? ? cocktail.save! : next
    ingredient = Ingredient.new(name: drink['strIngredient1'])
    ingredient.valid? ? ingredient.save! : next
    dose = Dose.new(description: drink['strMeasure1'])
    dose.ingredient = ingredient
    dose.cocktail = cocktail
    dose.valid? ? dose.save! : next
  end
end

puts 'Database seeded'
