class CreatePostPets < ActiveRecord::Migration[6.1]
  def change
    create_table :post_pets do |t|
      t.string :title, null: false
      t.text :introduction, null: false

      t.timestamps
    end
  end
end