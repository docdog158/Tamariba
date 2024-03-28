class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_normal_user, except: [:index ,:show]

  def ensure_normal_user
    if current_customer.email == 'guest@example.com'
      redirect_to about_path
    end
  end

  def index
    @customers = Customer.page(params[:page]).per(12)
  end
  def show
    @customer = Customer.find(params[:id])
    @post_pets = @customer.post_pets
    #チャット機能
    @currentCustomerEntry = Entry.where(customer_id: current_customer.id)
    @customerEntry = Entry.where(customer_id: @customer.id)
    unless @customer.id == current_customer.id
      @currentCustomerEntry.each do |cu|
        @customerEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = Customer.find(current_customer.id)
    if @customer.update(customer_params)
      redirect_to customer_path
    else
      render :edit
    end
  end

  def liked_posts
    @customer = Customer.find(params[:id])
    @liked_posts = PostPet.liked_posts(@customer, params[:page], 12)
  end

  def unsubscribe
    @customer = current_customer
  end

  def destroy
    @customer = current_customer
    @customer.destroy
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :introduction)
  end
end
