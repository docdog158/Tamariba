class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

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