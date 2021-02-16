require "alphavantagerb"

class StocksController < ApplicationController
  def index
    key = ENV["ALPHAVANTAGE_KEY"]
    client = Alphavantage::Client.new key: key

    searched = params[:search].present?

    if searched
      keywords = params[:search]

      lists = List.where(title: keywords)
      if lists.empty?
        stocks_found = client.search keywords: keywords
        stocks = stocks_found.output

        stocks_list = List.new(title: keywords, output: stocks)
        stocks_list.save

      else
        stocks_list = lists.first
      end

      @stocks = stocks_list.output.values[0]
    end

    searched ? @stocks = stocks_list.output.values[0] : @stocks = []

    # stock_name = stock.output.first[1].first.values.second
    # stock_ticker = stock.output.first[1].first.values.first
  end

  def add_stock
    selected_stock = params.values

    stock = Stock.where(ticker: selected_stock.first)

    if stock.empty?
      new_stock = Stock.new(name: selected_stock.second, ticker: selected_stock.first, region: selected_stock[3], currency: selected_stock[7])
      new_stock.save
      new_stock.update_stock

      user_stock = UserStock.new(user: current_user, stock: new_stock)
      user_stock.save

    else
      user_stock = UserStock.where(user: current_user, stock: stock.first)

      if user_stock.empty?
        user_stock = UserStock.new(user: current_user, stock: stock.first)
        user_stock.save
      end
    end

    redirect_to my_stocks_path
  end

  def refresh_stock
    stock = Stock.find(params[:format])
    stock.update_stock

    redirect_to my_stocks_path
  end

  def my_stocks
    stocks = current_user.stocks

    # @my_stocks.each(&:update_stock).sort_by! { |stock| [-stock.price_score] }
    @my_stocks = stocks.order(price_score: :desc)
  end
end
