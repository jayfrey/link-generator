class UrlVisitIntervalChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:room]}"
  end

  def receive(data)
    now = DateTime.now
    count = Url.joins(:statistics).where(slug: data['slug'], statistics: { created_at: (data['graph_interval']/1000).second.ago..now }).count()
    ActionCable.server.broadcast("#{params[:room]}", {count: count, now: now.strftime("%M:%S")})
  end
end
