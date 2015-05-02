##MeCab  
`/usr/local/etc/mecabrc` の `userdic`のコメントアウトを外し、使用したいユーザー辞書のパスを指定する。  
**単語の追加方法**  
※最後のuserdicの複数指定可能な書き方以外は最初にやったユーザー辞書作成の手順と同じ。  
新しいcsvファイルを作成。それから新しいdicファイルを作成。  
辞書のコンパイルをして、`/usr/local/lib/mecab/dic/ipadic/dicrc` もしくは `/usr/local/etc/mecabrc` の `userdic`へ追記。  
CSVフォーマットで複数指定可能。  
例:  
` userdic = /home/foo/bar/foo.dic,/home/foo/bar2/usr.dic,/home/foo/bar3/bar.dic`  
  
##whenever  
設定の確認  
`bundle exec whenever`  
cronにデータを反映  
`bundle exec whenever --update-crontab`  
cronからデータを削除  
`bundle exec whenever --clear-crontab`  
