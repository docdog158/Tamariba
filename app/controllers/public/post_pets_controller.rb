class Public::PostPetsController < ApplicationController
  before_action :authenticate_customer!, except: [:index]
  before_action :ensure_normal_user, except: [:index ,:show]

  def ensure_normal_user
    if current_customer.email == 'guest@example.com'
      redirect_to about_path
    end
  end

  def new
    @post_pet = PostPet.new
  end

  def edit
    @post_pet = PostPet.find(params[:id])

  end

  def show
    @post_pet = PostPet.find(params[:id])
    @customer = @post_pet.customer
    @tag_list = @post_pet.tags.pluck(:name).join(',')
    @post_tags = @post_pet.tags
    @post_comment = PostComment.new
  end

  def index
    @post_pets = PostPet.all
    @tag_list = Tag.all
  end

  def create
    @post_pet = current_customer.post_pets.build(post_pet_params)
    @tag_list = params[:post_pet][:name].split(',')
    if @post_pet.save
      @post_pet.save_tags(@tag_list)
      redirect_to post_pet_path(@post_pet), notice:'投稿が完了しました'
    else
      render 'new'
    end
  end

  def search_tag
    @tag = Tag.find(params[:tag_id])
    @tag_list = Tag.all
    @post_pets = @tag.post_pets
  end

  def destroy
    @post_pet = PostPet.find(params[:id])
    @post_pet.destroy
    redirect_to post_pets_path
  end

  def update
    @post_pet = PostPet.find(params[:id])
    if @post_pet.update(post_pet_params)
      redirect_to post_pet_path(@post_pet), notice:'投稿を編集しました'
    else
      render "show"
    end
  end

  private

  def post_pet_params
    params.require(:post_pet).permit(:title, :content, :image)
  end

end
