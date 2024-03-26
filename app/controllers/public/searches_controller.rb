class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search

    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー検索"
      @customers = Customer.looks(params[:range], params[:word])
    else
      @post_pets = PostPet.looks(params[:range], params[:word])
    end
  end
end
