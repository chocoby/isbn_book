# Bookscan に必要な情報
class Bookscan
  # 1 冊として処理できるページ数
  INITIAL_PAGE_COUNT = 350

  # 超過した分の追加ページ数
  EXTRA_PAGE_COUNT = 200

  attr_reader :volume_count

  def initialize(page_count)
    @page_count = page_count
  end

  # Bookscan 上の冊数
  def volume_count
    over_page_count = @page_count - INITIAL_PAGE_COUNT
    (over_page_count.to_f / EXTRA_PAGE_COUNT).ceil + 1
  end
end
