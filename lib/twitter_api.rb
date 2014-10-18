class TwitterApi
  def self.fetch_tweets_for(query, options = {:country => :in})
    responce = Array.new
    geo_codes = YAML.load_file("#{Rails.root}/config/countries/#{options[:country]}.yml")

    geo_codes.each do |state, geo_code|
      result = TwitterClient.search(query, :geocode => geo_code)
      responce << { "hc-key" => state, "value" => result.count }
    end
    responce
  end
end
