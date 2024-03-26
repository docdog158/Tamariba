class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.all
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tags_path
  end
end
