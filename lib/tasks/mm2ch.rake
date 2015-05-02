require 'nokogiri'
require 'anemone'
require 'natto'

namespace :mm2ch do
  desc "get info"
  task :create => :environment do
    get_info
  end
end

def get_info
  opts = {
    depth_limit: 0
  }

  # puts "Create Article ..."
  Anemone.crawl("http://labo.tv/2chnews/", opts) do |anemone|
    anemone.on_every_page do |page|
      page.doc.xpath("/html/body/center[2]//td[@valign='top']/div").each do |div|
        div.xpath("./ul/li").each do |list|
          text = list.xpath("./a/text()").to_s
          url = list.xpath("./a/@href").to_s
          tweet_limit = 140
          url_maximum_value = 23

          if url.size > 23
            url_number_of_characters = 23
          else
            url_number_of_characters = url.size
          end
          text_maximum_value = tweet_limit - (url_number_of_characters + 1 + 3)
          text = (text.size > text_maximum_value ? "#{text[0..text_maximum_value]}..." : text)

          text_parse = Array.new
          nm = Natto::MeCab.new
          nm.parse(text) do |n|
            text_parse << n.surface unless n.surface.empty?
          end
          check_ban_word = 0
          check_ban_word = (ban_word = text_parse & EroticWord.all_word).size
          ban_word = ban_word.join('') if check_ban_word != 0
          if check_ban_word == 0
            catch :miss do
              text_parse.each do |text|
                EroticWord.all_word.each do |word|
                  if text.size >= 2 && text.include?(word)
                    check_ban_word += 1
                    ban_word = word
                    throw :miss
                  end
                end
              end
            end
          end
          if check_ban_word == 0
            tweet_text = text + " " + url
            Article.create(tweet_text: tweet_text, text: text, url: url)
          else
            tweet_text = text + " " + url
            BanArticle.create(tweet_text: tweet_text, text: text, url: url, ban_word: ban_word)
          end
        end
      end
    end
  end
end
