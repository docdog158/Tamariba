class Public::PostPetsController < ApplicationController
  def new
    @post_pet = PostPet.new
  end
  
  def edit
  end
  
  def show
    @post_pet = Post.find(params[:id])
    @customer = @post_pet.customer
    @comment = Comment.new
  end
  
  def index
    @posts = Post_pet.all
  end
  
  def create
    @post_pet = Post_pet.new(post_params)
    @post_pet.customer_id = current_customer.id
    @post_petimage.save
    redirect_to post_pet_path
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
  def post_params
    params.require(:post_pet).permit(:title, :introduction, :image)
  end
  
end
