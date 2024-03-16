class ApplicationController < ActionController::Base
before_action :search

  def search
    @q = PostPet.ransack(params[:q])
    @post_pet = @q.result(distinct: true)
    @result = params[:q]&.values&.reject(&:blank?)
  end
end