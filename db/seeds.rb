# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
   email: 'admin@admin',
   password: ENV['SECRET_KEY']
)

test1 = Customer.find_or_create_by!(email: "test1@example.com") do |customer|
  customer.name = "test1"
  customer.password = "password1"
end

test2 = Customer.find_or_create_by!(email: "test2@example.com") do |customer|
  customer.name = "test2"
  customer.password = "password2"
end

test3 = Customer.find_or_create_by!(email: "test3@example.com") do |customer|
  customer.name = "test3"
  customer.password = "password3"
end

PostPet.find_or_create_by!(title: "ミルワーム") do |post_pet|
  post_pet.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post_pet.content = "増えてました。"
  post_pet.customer = test1
end

PostPet.find_or_create_by!(title: "レオパードゲッコー") do |post_pet|
  post_pet.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename:"sample-post2.jpg")
  post_pet.content = "おいしそうですね！"
  post_pet.customer = test2
end

PostPet.find_or_create_by!(title: "へびのいのち") do |post_pet|
  post_pet.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename:"sample-post3.jpg")
  post_pet.content = 'いのちがあります'
  post_pet.customer = test3
end