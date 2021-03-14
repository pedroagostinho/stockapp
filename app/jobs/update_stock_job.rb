class UpdateStockJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "I'm starting the fake job"
    stock.all.each do |stock|
      stock.update_stock
      sleep 60
    end
    puts "OK I'm done now"
  end
end
