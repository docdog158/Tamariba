class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー検索"
      @customers = Customer.looks(params[:search], params[:word])
    else
      @post_pets = PostPet.looks(params[:search], params[:word])
    end
  end
end
