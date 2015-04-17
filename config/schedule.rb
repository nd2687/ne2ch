set :output, 'log/crontab.log'
set :environment, :production

env :PATH, ENV['PATH']

every 14.minute do
  rake "twitter:tweet"
end

every :hour do
  rake "mm2ch:create"
end

every :day do
  rake "twitter:follow"
end

every 3.hours do
  rake "twitter:refollow"
end
