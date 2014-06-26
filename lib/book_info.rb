require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'yaml'

# 書籍情報
class BookInfo
  attr_reader :isbn, :title, :price, :publisher, :page_count

  class << self
    # Application ID の検証
    def check_application_id
      application_id = YAML.load_file('./setting.yml')['application_id']
    rescue
      puts 'Error: setting.yml.sample をコピーして setting.yml を作成し、 application_id を設定してください'
      exit
    else
      if application_id.nil? || application_id.empty?
        puts 'Error: setting.yml に application_id を設定してください'
        exit
      end
    end
  end

  def initialize(isbn)
    @isbn = isbn
    @application_id = YAML.load_file('./setting.yml')['application_id']
  end

  # 書籍情報を取得
  def fetch!
    fetch_page_info
    fetch_page_count
  end

  # 楽天ブックス書籍検索 API から書籍情報を取得
  def fetch_page_info
    uri = URI.parse("https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522?applicationId=#{@application_id}&isbn=#{@isbn}")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)

    @title      = result['Items'][0]['Item']['title']
    @price      = result['Items'][0]['Item']['itemPrice']
    @publisher  = result['Items'][0]['Item']['publisherName']
    @item_url   = result['Items'][0]['Item']['itemUrl']
  end

  # 楽天の商品ページから書籍のページ数を取得
  def fetch_page_count
    uri = URI.parse(@item_url)
    res = Net::HTTP.get(uri)
    doc = Nokogiri::HTML(res)

    @page_count =
      doc.xpath('//div[@id="productIdentifier"]//span[text()="・ページ数"]/parent::*/parent::*/dd').first.content.to_i
  end
end
