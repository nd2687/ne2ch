require 'twitter'

namespace :twitter do
  desc "tweet"
  task :tweet => :environment do
    client = get_twitter_client
    recent_articles = Article.where(created_at: (Time.now-60*60)..Time.now)
    i = 0
    while i < 5 do
      article = recent_articles.sample
      next if article.tweeted?
      tweet = article.tweet_text
      article.update(tweeted: true)
      update(client, tweet)
      i += 1
    end
  end

  desc "follow"
  task :follow => :environment do
    client = get_twitter_client
    follow(client)
  end
end

def get_twitter_client
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = Settings.consumer_key
    config.consumer_secret     = Settings.consumer_secret
    config.access_token        = Settings.access_token
    config.access_token_secret = Settings.access_token_secret
  end
  client
end

def update(client, tweet)
  begin
    tweet = (tweet.length > 140) ? tweet[0..139].to_s : tweet
    client.update(tweet.chomp)
  rescue => e
    Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
  end
end

def follow(client)
  followers = []
  client.follower_ids.each_slice(100) do |ids|
    followers.concat client.users(ids)
  end
  client.follow(followers)
end
