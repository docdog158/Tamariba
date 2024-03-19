class Public::FavoritesController < ApplicationController
  def create
    post_pet = PostPet.find(params[:post_pet_id])
    favorite = current_customer.favorites.new(post_pet: post_pet) 
    favorite.save
    request.referer
  end

  def destroy
    post_pet = PostPet.find(params[:post_pet_id])
    favorite = current_customer.favorites.find_by(post_pet: post_pet)
    favorite.destroy
    request.referer
  end
  
end
