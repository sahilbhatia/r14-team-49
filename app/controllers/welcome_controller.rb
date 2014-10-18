class WelcomeController < ApplicationController
  def fetch_tweets
    @result_set = TwitterApi.fetch_tweets_for(safe_params[:query], :country => safe_params[:country]).to_json
    render :index
  end

  private

  def safe_params
    params.fetch(:criteria, {}).permit(:query, :country)
  end
end
