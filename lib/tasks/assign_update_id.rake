desc "Assign update id"
task assign_update_id: :environment do
  puts "Assigning_update ids"

  stocks = Stock.all

  stocks.each do |stock|
    if stock.id <= 121
      stock.update(update_id: 0)
    elsif stock.id <= 242
      stock.update(update_id: 1)
    elsif stock.id <= 363
      stock.update(update_id: 2)
    elsif stock.id <= 484
      stock.update(update_id: 3)
    elsif stock.id <= 605
      stock.update(update_id: 4)
    elsif stock.id <= 726
      stock.update(update_id: 5)
    elsif stock.id <= 847
      stock.update(update_id: 6)
    else
      stock.update(update_id: Date.today.wday)
    end
  end

  puts "Update_ids assigned!"
end
