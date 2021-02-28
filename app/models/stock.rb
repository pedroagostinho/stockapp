class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  ANALYSIS_DAYS = 2000
  MAX_SCORE = 5
  MIN_SCORE = 1

  def calculate_price_score
    # (PRICE-MAX)*(5-1)/(MIN-MAX)+1
    price_score = (price - max_price) * (MAX_SCORE - MIN_SCORE) / (min_price - max_price) + MIN_SCORE
    update(price_score: price_score)
  end

  def calculate_hype_score
    # (VOLUME-AVG)/VOLUME
    hype_score = (volume - avg_volume) / volume
    update(hype_score: hype_score)
  end

  def update_fundamentals
    require 'json'
    require 'open-uri'

    key = ENV["ALPHAVANTAGE_KEY"]
    url = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker}&apikey=#{key}"

    company_overview_serialized = URI.open(url).read
    company_overview = JSON.parse(company_overview_serialized)

    update(description: company_overview["Description"],
           pe_ratio: company_overview["PERatio"].to_f,
           peg_ratio: company_overview["PEGRatio"].to_f,
           forward_pe: company_overview["ForwardPE"].to_f,
           dividend_yield: company_overview["DividendYield"].to_f,
           year_high: company_overview["52WeekHigh"].to_f,
           year_low: company_overview["52WeekLow"].to_f)
  end

  def update_stock
    key = ENV["ALPHAVANTAGE_KEY"]
    # client = Alphavantage::Client.new key: key

    # stock = client.stock symbol: ticker
    # stock_price = stock.quote.price
    # stock_volume = stock.quote.volume

    timeseries = Alphavantage::Timeseries.new symbol: ticker, key: key, type: "daily", adjusted: true, outputsize: "full"
    stock_price = timeseries.adjusted_close.first[1]
    stock_volume = timeseries.volume.first[1]

    update(price: stock_price, volume: stock_volume)

    price_timeseries = Hash[timeseries.adjusted_close.first(ANALYSIS_DAYS).map { |k, v| [Date.strptime(k, "%Y-%m-%d"), v.to_f] }]
    min_price = [price_timeseries.min_by { |_k, v| v }].to_h.values.first
    min_price_date = [price_timeseries.min_by { |_k, v| v }].to_h.keys.first
    max_price = [price_timeseries.max_by { |_k, v| v }].to_h.values.first
    max_price_date = [price_timeseries.max_by { |_k, v| v }].to_h.keys.first

    update(min_price: min_price, min_price_date: min_price_date, max_price: max_price, max_price_date: max_price_date)

    volume_timeseries = Hash[timeseries.volume.first(ANALYSIS_DAYS).map { |k, v| [Date.strptime(k, "%Y-%m-%d"), v.to_i] }]
    min_volume = [volume_timeseries.min_by { |_k, v| v }].to_h.values.first
    min_volume_date = [volume_timeseries.min_by { |_k, v| v }].to_h.keys.first
    max_volume = [volume_timeseries.max_by { |_k, v| v }].to_h.values.first
    max_volume_date = [volume_timeseries.max_by { |_k, v| v }].to_h.keys.first
    avg_volume = volume_timeseries.values.sum(0.0) / volume_timeseries.values.size

    update(min_volume: min_volume, min_volume_date: min_volume_date, max_volume: max_volume, max_volume_date: max_volume_date, avg_volume: avg_volume)

    calculate_price_score
    calculate_hype_score

    update_fundamentals
  end
end
