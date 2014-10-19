class WelcomeController < ApplicationController
  def index
    # list all team members
    @members = TEAM_MEMBERS

    # 'Geocoder' gem provides 'location' method on 'request' object
    # passing location information to retrieve country code
    @country_code = get_country_code_from_location(request.location)
  end

  def fetch_tweets
    # TEAM_MEMBERS constant is defined in config/initializers/team_member.rb
    @members = TEAM_MEMBERS

    # fetch tweets using twitter API
    @result_set = TwitterApi.fetch_tweets_for(safe_params[:query], country: safe_params[:country]).to_json

    render :json => @result_set
  end

  private

  def safe_params
    params.fetch(:criteria, {}).permit(:query, :country)
  end

  def get_country_code_from_location(location)
    if location.present? && location.data['ip'] != "127.0.0.1"
      country_code = location.data['country_code'].try(:downcase)
    else
      country_code = 'in'
    end
  end
end
