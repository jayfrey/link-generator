class LinksController < ApplicationController
  def visit
    url = Url.find_by(slug: params[:slug])
    return unless url

    # record statistics
    stat = url.record_statistics(
      remote_ip: request.remote_ip,
      user_agent: request.user_agent,
      referrer: request.referrer,
    )

    # broadcast event to anyone listening in
    UrlVisitChannel.broadcast_to(url.slug, stat.to_json)

    # do the redirection
    redirect_to url.url
  end
end
