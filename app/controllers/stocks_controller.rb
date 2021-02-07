require "alphavantagerb"

class StocksController < ApplicationController
  def index
    key = ENV["ALPHAVANTAGE_KEY"]
    client = Alphavantage::Client.new key: key
    stocks_found = client.search keywords: "MSFT"
    @stocks = stocks_found.output
  end
end
