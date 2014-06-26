require 'csv'

require_relative './lib/bookscan.rb'
require_relative './lib/book_info.rb'

BookInfo.check_application_id

results = []
errors  = []

input_file  = ARGV[0]
output_file = ARGV[1]

CSV.foreach(input_file, headers: true, col_sep: ', ') do |row|
  isbn = row['data']

  book_info = BookInfo.new(isbn)

  begin
    book_info.fetch!
    puts "#{book_info.isbn}: #{book_info.title}"
  rescue
    puts "#{isbn}: ERROR"
    errors << isbn
    next
  end

  bookscan = Bookscan.new(book_info.page_count)

  results << [
    book_info.isbn,
    book_info.title,
    book_info.publisher,
    book_info.price,
    book_info.page_count,
    bookscan.volume_count
  ]

  sleep 1
end

CSV.open(output_file, 'wb', col_sep: "\t") do |csv|
  results.each { |row| csv << row }
end

puts '-' * 20

if errors.count > 0
  puts 'Errors:'
  errors.each { |e| puts e }
end
