class Public::PostPetsController < ApplicationController
  def new
    @post_pet = PostPet.new
  end
  
  def edit
  end
  
  def show
    @post_pet = PostPet.find(params[:id])
    @customer = @post_pet.customer
    #@comment = Comment.new
  end
  
  def index
    @post_pets = PostPet.all
  end
  
  def create
    @post_pet = current_customer.post_pets.build(post_pet_params)
    if @post_pet.save
      redirect_to post_pet_path(@post_pet)
    else
      render 'new'
    end
  end
  
  
  def destroy
    
  end
  
  def update
    if @post_pet.update(post_params)
      redirect_to post_path(@post_pet)
    else
      render "show"
    end
  end
  
  private
  
  def post_pet_params
    params.require(:post_pet).permit(:title, :content, :image)
  end
  
end
