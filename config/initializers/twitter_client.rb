unless Rails.env.production? 
  credential = YAML.load_file("#{Rails.root}/config/twitter_credential.yml")
  ENV['TWITTER_CONSUMER_KEY'] = credential['consumer_key']
  ENV['TWITTER_CONSUMER_SECRET'] = credential['consumer_secret']
end

config = {
  :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
  :consumer_secret => ENV['TWITTER_CONSUMER_SECRET']
}

# initialize twitter client
TwitterClient = Twitter::REST::Client.new(config)

# fetch bearer token
TwitterClient.token

