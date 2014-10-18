class WelcomeController < ApplicationController
  def fetch_tweets
    @result_set = TwitterApi.fetch_tweets_for(safe_params[:query], :country => safe_params[:country]).to_json
    render :index
  end

  private

  def safe_params
    params.fetch(:criteria, {}).permit(:query, :country)
  end

  def get_country_code
    if params[:coordinates].present?
      country_code = Geocoder.search(params[:coordinates]).last.address_components.last['short_name'].downcase
      render json: { country_code: country_code } and return
    else
      render json: { error: 'Invalid or no coordinates...' } and return
    end
  end
end
