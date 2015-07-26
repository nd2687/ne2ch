set :output, 'log/crontab.log'
set :environment, :production

env :PATH, ENV['PATH']

every 28.minute do
  rake "twitter:tweet"
end

every :hour do
  rake "mm2ch:create"
  rake "twitter:searching"
  rake "twitter:unfollow"
end

every :day do
  rake "twitter:follow"
end
