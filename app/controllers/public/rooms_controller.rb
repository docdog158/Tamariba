class Public::RoomsController < ApplicationController
  before_action :authenticate_customer!
  before_action :reject_non_related, only: [:show]

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, customer_id: current_customer.id)
    @entry2 = Entry.create(params.require(:entry).permit(:customer_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(customer_id: current_customer.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

    def reject_non_related
      room = Room.find(params[:id])
      customer = room.entries.where.not(customer_id: current_customer.id).first.customer
      unless (current_customer.following?(customer)) && (customer.following?(current_customer))
        redirect_to post_pets_path
      end
    end
end