class UrlVisitIntervalChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:room]}"
  end

  def receive(data)
    count = Statistic.where(created_at: (data['graph_interval']/1000).second.ago..DateTime.now).count()
    ActionCable.server.broadcast("#{params[:room]}", {count: count})
  end
end
