class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search

    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "ユーザー検索"
      @customers = Customer.looks(@search, @word)
    else
      @post_pets = PostPet.looks(@search, @word)
    end
  end
end