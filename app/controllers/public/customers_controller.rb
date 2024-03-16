class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  def index
    @customers = Customer.page(params[:page]).per(10)
  end
  def show
    @customer = Customer.find(params[:id])

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
    @liked_posts = PostPet.liked_posts(current_customer, params[:page], 12)
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
