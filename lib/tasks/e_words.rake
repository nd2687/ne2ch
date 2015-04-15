require 'nokogiri'
require 'anemone'
require 'kconv'

namespace :e_words do
  desc "create e_words"
  task :create => :environment do
    get_e_words
  end
end

def get_e_words
  opts = {
    depth_limit: 1
  }

  Anemone.crawl("http://www.tokyo-harem.com/dictionary/01a.html", opts) do |anemone|
    anemone.focus_crawl do |page|
      page.links.keep_if{|link|
        link.to_s.match(%r[http://www.tokyo-harem.com/dictionary/\d{2}[a-z]{1,2}.html])
      }
    end

    puts "Create EroticWord ..."
    anemone.on_pages_like(%r[http://www.tokyo-harem.com/dictionary/\d{2}[a-z]{1,2}.html]) do |page|
      doc = Nokogiri::HTML.parse(page.body.toutf8)

      5.step(17, 3){|i|
        doc.xpath("/html/body//div[@align='center']/table[1]//td[1]/table[#{i}]//tr").each do |node|
          word = node.xpath("./td[1]//b/font[1]/text()").to_s
          EroticWord.create(word: word.to_s, first_word: get_first(word.to_s)) unless word.size == 0
        end
      }
    end
  end
end

def get_first(word)
  return word[0]
end
