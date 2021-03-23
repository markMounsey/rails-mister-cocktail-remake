require 'json'
require 'open-uri'

puts 'cleaning the database'
Ingredient.destroy_all

letters_of_the_alphabet = ('a'..'c').to_a

letters_of_the_alphabet.each do |letter|
  url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"
  drinks_serialized = open(url).read
  json_file = JSON.parse(drinks_serialized)

  json_file['drinks'].each do |drink|
    ingredient = Ingredient.new(name: drink['strIngredient1'])
    if ingredient.valid?
      ingredient.save!
    else
      next
    end
  end
end
