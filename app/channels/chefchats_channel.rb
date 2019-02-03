class ChefchatsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chefchats_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
