class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params['title'].present?
      payload = MovieService.by_title(params['title'])
    else
      payload = MovieService.all
    end
    status = :ok
    meta = nil
    if payload.blank?
      status = 400
      meta = {message: 'Not Found'}
    end
    render json: { payload: payload, meta: meta },
           status: status
  end

  def sync
    affected_records = MovieService.sync
    render json: { payload: nil, meta: { affected_records: affected_records } },
           status: :ok
  end

  def search
    render json: {method: 'search'}
  end
end
