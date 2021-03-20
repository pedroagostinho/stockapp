desc "Import Revolut stocks"
task import_stocks: :environment do
  filepath = 'lib/assets/revolut_stocks.csv'

  csv_options = {
    col_sep: ';',
    quote_char: '"',
    headers: :first_row,
    header_converters: :symbol
  }

  key = ENV["ALPHAVANTAGE_KEY"]
  client = Alphavantage::Client.new key: key

  CSV.foreach(filepath, csv_options) do |row|
    ticker = row[:ticker]

    puts "Importing #{ticker}..."

    stocks_found = client.search keywords: ticker
    next unless stocks_found.present?

    stock = Stock.where(ticker: ticker)
    pedro = User.find(1)

    if stock.empty?
      new_stock = Stock.new(name: stocks_found.stocks[0].name,
                            ticker: ticker,
                            region: stocks_found.stocks[0].region,
                            currency: stocks_found.stocks[0].currency)
      puts "#{ticker} stock created!" if new_stock.save
      new_stock.update_stock

      user_stock = UserStock.new(user: pedro, stock: new_stock)
      user_stock.save

    else
      puts "#{ticker} already existed..."
      user_stock = UserStock.where(user: pedro, stock: stock.first)

      if user_stock.empty?
        user_stock = UserStock.new(user: pedro, stock: stock.first)
        user_stock.save
      end
    end

    sleep 30

    puts "Finished importing #{ticker}! Moving on..."
  end

end
