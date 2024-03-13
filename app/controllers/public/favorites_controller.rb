class Public::FavoritesController < ApplicationController
  def create
    post_pet = PostPet.find(params[:post_pet_id])
    favorite = current_customer.favorites.new(post_pet: post_pet) 
    favorite.save
    redirect_to post_pet_path(post_pet)
  end

  def destroy
    post_pet = PostPet.find(params[:post_pet_id])
    favorite = current_customer.favorites.find_by(post_pet: post_pet)
    favorite.destroy
    redirect_to post_pet_path(post_pet)
  end
end
