desc "Update all stocks"
task update_stocks: :environment do
  puts "Udating stocks"

  Stock.all.each do |stock|
    stock.update_stock
    sleep 60
  end

  puts "Stocks updated!"
end
