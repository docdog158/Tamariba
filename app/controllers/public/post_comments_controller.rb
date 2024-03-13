class Public::PostCommentsController < ApplicationController

  def create
    post_pet = PostPet.find(params[:post_pet_id])
    comment = current_customer.post_comments.new(post_comment_params)
    comment.post_pet_id = post_pet.id
    comment.save
    redirect_to post_pet_path(post_pet)
  end
  
  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
    
    #respond_to do |format|
      #ormat.js
    #end
    redirect_to request.referer
  end
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end