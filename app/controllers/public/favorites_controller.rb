class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_normal_user

  def ensure_normal_user
    if current_customer.email == 'guest@example.com'
      redirect_to about_path
    end
  end

  def create
    @post_pet = PostPet.find(params[:post_pet_id])
    favorite = current_customer.favorites.new(post_pet: @post_pet)
    favorite.save
    post.create_notification_like!(current_customer)
  end

  def destroy
    @post_pet = PostPet.find(params[:post_pet_id])
    favorite = current_customer.favorites.find_by(post_pet: @post_pet)
    favorite.destroy
  end
end
