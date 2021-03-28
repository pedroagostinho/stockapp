desc "Update all stocks"
task update_stocks: :environment do
  puts "Updating stocks"

  weekday = Date.today.wday
  stocks = Stock.where(update_id: weekday)

  stocks.each do |stock|
    stock.update_stock
    sleep 30
  end

  puts "Stocks updated!"
end
