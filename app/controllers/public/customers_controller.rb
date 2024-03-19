class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  def index
    @customers = Customer.page(params[:page]).per(10)
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
    @customer = Customer.find(params[:id])
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
  end

  def withdraw
    @customer = Customer.find(current_customer.id)
    @customer.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :introduction)
  end
end
