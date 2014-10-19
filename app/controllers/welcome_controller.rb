class WelcomeController < ApplicationController

  def index
    # 'Geocoder' gem provides 'location' method on 'request' object
    # passing location information to retrieve country code
    @country_code = get_country_code_from_location(request.location)
  end

  def fetch_tweets
    @result = TwitterClient.search(safe_params[:query], :geocode => safe_params[:geocode])
    render :json => @result.count
  end

  private

  def safe_params
    params.fetch(:criteria, {}).permit(:query, :geocode)
  end

  def get_country_code_from_location(location)
    if location.present? && location.data['ip'] != "127.0.0.1"
      country_code = location.data['country_code'].try(:downcase)
    else
      country_code = 'in'
    end
  end
end
