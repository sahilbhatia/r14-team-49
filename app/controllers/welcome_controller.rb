class WelcomeController < ApplicationController
  def index
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
