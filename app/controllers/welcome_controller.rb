class WelcomeController < ApplicationController
  def fetch_tweets
    @result = TwitterClient.search(safe_params[:query], :geocode => safe_params[:geocode])
    render :json => @result.count
  end

  def get_country_code
    if params[:coordinates].present?
      country_code = Geocoder.search(params[:coordinates]).last.address_components.last['short_name'].downcase
      render json: { country_code: country_code } and return
    else
      render json: { error: 'Invalid or no coordinates...' } and return
    end
  end

  private

  def safe_params
    params.fetch(:criteria, {}).permit(:query, :geocode)
  end

end
