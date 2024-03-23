class Public::MessagesController < ApplicationController
  def create
    if Entry.where(customer_id: current_customer.id, room_id: params[:message][:room_id]).present?
      @message = Message.new(message_params)
      @message.customer_id = current_customer.id
      @message.save!
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
    end
    render :validater unless @message.save
  end

  private

    def message_params
      params.require(:message).permit(:customer_id, :room_id, :content)
    end
end
