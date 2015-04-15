set :output, 'log/crontab.log'
set :environment, :production

env :PATH, ENV['PATH']

every ' * * * * * ' do
  rake "twitter:tweet"
end

every :hour do
  rake "mm2ch:create"
end
