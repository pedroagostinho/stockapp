class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  SECTORS = ["Consumer Cyclical", "Communication Services", "Financial Services",
             "Technology", "Consumer Defensive", "Basic Materials", "Healthcare",
             "Industrials", "Real Estate", "Utilities", "Energy"]

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

  def calculate_current_price_score
    max_current_price = Stock.all.pluck(:price).max
    min_current_price = Stock.all.pluck(:price).min

    # (PRICE-MAX)*(5-1)/(MIN-MAX)+1
    current_price_score = (price - max_current_price) * (MAX_SCORE - MIN_SCORE) / (min_current_price - max_current_price) + MIN_SCORE
    update(current_price_score: current_price_score)
  end

  def calculate_pe_ratio_score
    max_pe_ratio = Stock.all.pluck(:pe_ratio).max
    min_pe_ratio = Stock.all.pluck(:pe_ratio).min

    # (PE RATIO-MAX)*(5-1)/(MIN-MAX)+1
    pe_ratio_score = (pe_ratio - max_pe_ratio) * (MAX_SCORE - MIN_SCORE) / (min_pe_ratio - max_pe_ratio) + MIN_SCORE
    update(pe_ratio_score: pe_ratio_score)
  end

  def update_fundamentals
    require 'json'
    require 'open-uri'

    key = ENV["ALPHAVANTAGE_KEY"]
    url = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker}&apikey=#{key}"

    company_overview_serialized = URI.open(url).read
    company_overview = JSON.parse(company_overview_serialized)

    update(description: company_overview["Description"],
           sector: company_overview["Sector"],
           industry: company_overview["Industry"],
           pe_ratio: company_overview["PERatio"].to_f,
           peg_ratio: company_overview["PEGRatio"].to_f,
           forward_pe: company_overview["ForwardPE"].to_f,
           dividend_yield: company_overview["DividendYield"].to_f,
           year_high: company_overview["52WeekHigh"].to_f,
           year_low: company_overview["52WeekLow"].to_f)

    pe_ratio_evolution = pe_ratio - forward_pe
    update(pe_ratio_evolution: pe_ratio_evolution)
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

    # calculate_current_price_score
    # calculate_pe_ratio_score

    update_fundamentals
  end

  def sector_icon
    if sector == SECTORS[0]
      "<i class='fas fa-car'></i>".html_safe
    elsif sector == SECTORS[1]
      "<i class='fas fa-satellite-dish'></i>".html_safe
    elsif sector == SECTORS[2]
      "<i class='fas fa-coins'></i>".html_safe
    elsif sector == SECTORS[3]
      "<i class='fas fa-microchip'></i>".html_safe
    elsif sector == SECTORS[4]
      "<i class='fas fa-shopping-cart'></i>".html_safe
    elsif sector == SECTORS[5]
      "<i class='fas fa-tree'></i>".html_safe
    elsif sector == SECTORS[6]
      "<i class='fas fa-heartbeat'></i>".html_safe
    elsif sector == SECTORS[7]
      "<i class='fas fa-rocket'></i>".html_safe
    elsif sector == SECTORS[8]
      "<i class='far fa-building'></i>".html_safe
    elsif sector == SECTORS[9]
      "<i class='fas fa-faucet'></i>".html_safe
    elsif sector == SECTORS[10]
      "<i class='far fa-lightbulb'></i>".html_safe
    else
      "<i class='fas fa-question'></i>".html_safe
    end
  end
end
