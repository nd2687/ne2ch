namespace :dictionary do
  desc "download keyword file"
  task :download => :environment do
    download
  end

  desc "create custom csv"
  task :custom => :environment do
    custom
  end

  desc "create user_dictionary"
  task :create => :environment do
    create_dic
  end
end

def download
  # hatena
  system("curl -L http://d.hatena.ne.jp/images/keyword/keywordlist_furigana.csv | iconv -f euc-jp -t utf-8 > ./lib/keyword_files/keywordlist_furigana.csv")
  # wikipedia
  system("curl -L http://dumps.wikimedia.org/jawiki/latest/jawiki-latest-all-titles-in-ns0.gz | gunzip > ./lib/keyword_files/jawiki-latest-all-titles-in-ns0")
end

def custom
  require 'csv'

  original_data = {
    wikipedia: "#{Rails.root.join('lib', 'keyword_files')}" + "/jawiki-latest-all-titles-in-ns0",
    hatena: "#{Rails.root.join('lib', 'keyword_files')}" + "/keywordlist_furigana.csv"
  }

  CSV.open("#{Rails.root.join('lib', 'keyword_files', 'custom.csv')}", 'w') do |csv|
    original_data.each do |type, filename|
      next unless File.file? filename
      open(filename).each do |title|
        title.strip!

        next if title =~ %r(^[+-.$()?*/&%!"'_,]+)
        next if title =~ /^[-.0-9]+$/
        next if title =~ /曖昧さ回避/
        next if title =~ /_\(/
        next if title =~ /^PJ:/
        next if title =~ /の登場人物/
        next if title =~ /一覧/

        title_length = title.length

        if title_length > 3
          score = [-36000.0, -400 * (title_length ** 1.5)].max.to_i
          csv << [title, nil, nil, score, '名詞', '一般', '*', '*', '*', '*', title, '*', '*', type]
        end
      end
    end
  end
end

def create_dic
  # remote
  # system("/home/ziita/sub_apps/mecab-0.996/src/mecab-dict-index -d /usr/local/lib/mecab/dic/ipadic -u ./lib/keyword_files/custom.dic -f utf-8 -t utf-8 ./lib/keyword_files/custom.csv")
  # local
  # system("/usr/local/Cellar/mecab/0.996/libexec/mecab/mecab-dict-index -d /usr/local/Cellar/mecab/0.996/lib/mecab/dic/ipadic -u ./lib/keyword_files/custom.dic -f utf-8 -t utf-8 ./lib/keyword_files/custom.csv")
end
