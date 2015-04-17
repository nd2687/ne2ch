require 'twitter'

namespace :twitter do
  desc "tweet"
  task :tweet => :environment do
    client = get_twitter_client
    recent_articles = Article.where(created_at: (Time.now-60*60)..Time.now)
    tweet = recent_articles.sample.tweet_text
    update(client, tweet)
  end

  desc "refollow"
  task :refollow => :environment do
    client = get_twitter_client
    refollow(client)
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

def refollow(client)
  get_follower_or_friend(client)
  i = 1
  while i <= 10
    break if @follower_or_friend_id.size == 0
    @follower_or_friend_id.each do |user_id|
      if @followers_id.include?(user_id)
        client.follow(user_id)
      elsif @friends_id.include?(user_id)
        client.unfollow(user_id)
      else
        break
      end
      i += 1
      get_follower_or_friend(client)
    end
  end
end

def get_follower_or_friend(client)
  @followers_id = client.followers.map(&:id)
  @friends_id = client.friends.map(&:id)
  and_id = @followers_id && @friends_id
  sum_id = @followers_id + @friends_id
  @follower_or_friend_id = sum_id - and_id
end

def follow(client)
  friend = client.followers.take(5).sample.id
  users = client.followers(friend).take(6)
  nofriends = users.reject{|user| client.friendship?(client, user) }
  if nofriends.size > 0
    client.follow(nofriends)
  end
end
