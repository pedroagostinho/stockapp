desc "Add Revolut stocks to user"
# task :add_revolut_stocks [:user] => [:environment] do |_task, args|
task add_revolut_stocks: :environment do

  stocks = Stock.all
  # user = args.user.to_i
  user = User.find(5)

  stocks.each do |stock|
    user_stock = UserStock.where(user: user, stock: stock)

    if user_stock.empty?
      user_stock = UserStock.new(user: user, stock: stock)
      user_stock.save
    end
  end
end
