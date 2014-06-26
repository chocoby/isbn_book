# ISBN から書籍情報を取得/Bookscan 用の冊数を算出

## これは何

* ISBN から楽天ブックス書籍検索 API、楽天市場の商品ページを使用して書籍情報を取得する
* ページ数から [Bookscan](http://www.bookscan.co.jp/) で扱われる冊数を算出する
  * 冊数について: http://www.bookscan.co.jp/price.php

## 使い方

1. bundle install

2. `setting.yml.sample` を `setting.yml` にコピー。
   [楽天ウェブサービスの ID を発行し](https://webservice.rakuten.co.jp/app/create) `application_id` に設定

3. バーコードリーダー [mobiscan](https://itunes.apple.com/jp/app/shi-shide-shierubakodorida/id606982729?mt=8) で
   ISBN をスキャン、CSV で書き出す

4. CSV から書籍情報を取得し書き出す

   ```
   bundle exec ruby isbn_book.rb [INPUT] [OUTPUT]
   ```

5. Google Docs Spreadsheet にコピー & ペーストするなどして良しなに使う


## サンプル

### Input

[mobiscan](https://itunes.apple.com/jp/app/shi-shide-shierubakodorida/id606982729?mt=8) で読み取って
CSV を転送したデータ

```csv
data, typename, date, status, description, additional info
"9784774165165", "ISBN-13", "2014-06-25 15:30:40", 0, "unsent", ""
"9784774158792", "ISBN-13", "2014-06-25 15:30:34", 0, "unsent", ""
```

### Output

Google Docs Spreadsheet に貼り付けやすくするように TSV で書き出している。  
各項目は ISBN, 書籍名, 出版社, 価格, ページ数, Bookscan における冊数


```csv
9784774165165	パーフェクトRuby　on　Rails	技術評論社	3110	431	2
9784774158792	パーフェクトRuby	技術評論社	3456	639	3
```


## TODO

* Golang で書きなおしたい
* 書籍のサイズ情報を取ってきて段ボールに効率良く収納できるようにソートしたい


## ライセンス

MIT: http://chocoby.mit-license.org/
