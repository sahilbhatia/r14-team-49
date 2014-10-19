class TwitterApi
  def self.fetch_tweets_for(query, options = { country: 'in' })
    response = Array.new
    geo_codes = YAML.load_file("#{Rails.root}/config/countries/#{options[:country]}.yml")

    geo_codes.each do |state, geo_code|
      # 'TwitterClient' is initialized using twitter api gem,
      # defined in 'config/initializers/twitter_client.rb'
      result = TwitterClient.search(query, :geocode => geo_code)
      response << { "hc-key" => state, "value" => result.count }
    end
    response
  end
end
