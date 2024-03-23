class Admin::PostPetsController < ApplicationController
  
  def edit
    @post_pet = PostPet.find(params[:id])
  end

  def show
    @post_pet = PostPet.find(params[:id])
    @customer = @post_pet.customer
    @tag_list = @post_pet.tags.pluck(:name).join(',')
    @post_tags = @post_pet.tags
  end

  def index
    @post_pets = PostPet.all
    @tag_list = Tag.all
  end

  def search_tag
    @tag = Tag.find(params[:tag_id])
    @tag_list = Tag.all
    @post_pets = @tag.post_pets
  end

  def destroy
    @post_pet = PostPet.find(params[:id])
    @post_pet.destroy
    redirect_to admin_post_pets_path
  end

  private

  def post_pet_params
    params.require(:post_pet).permit(:title, :content, :image)
  end

end
