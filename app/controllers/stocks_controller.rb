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

  def my_stocks
  end
end
