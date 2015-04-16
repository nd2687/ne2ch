require 'nokogiri'
require 'anemone'
require 'kconv'

namespace :wikiero do
  desc "create e_words"
  task :create => :environment do
    get_wikiero
  end
end

def get_wikiero
  opts = {
    depth_limit: 0
  }

  puts "Create EroticWord ..."
  Anemone.crawl("http://seesaawiki.jp/smaero/d/%A2%A3%A5%A8%A5%ED%CD%D1%B8%EC%BC%AD%C5%B5#aiu/", opts) do |anemone|
    anemone.on_every_page do |page|
      ids = %w( 40 63 87 100 105 131 140 146 159 161 )
      ids.each{|id|
        page.doc.xpath("//*[@id='content_block_#{id}-inside']/b").each do |b|
          word = b.xpath("./span/text()").to_s
          word = word.kconv(Kconv::UTF8, Kconv::EUC)
          word.slice!(0)
          EroticWord.create(word: word.to_s, first_word: get_first(word.to_s)) unless word.size == 0
        end
      }
    end
  end
end

def get_first(word)
  return word[0]
end
