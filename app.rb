require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

helpers do
  def api_call
    api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
    raw_data = HTTP.get(api_url).to_s
    parsed_data = JSON.parse(raw_data)
    @symbols = parsed_data.fetch("currencies").keys
    # @symbols = parsed_data["currencies"].keys
  end

  def exchange_rate(current_currency, to_currency)
    api_url = "https://api.exchangerate.host/convert?from=#{current_currency}&to=#{to_currency}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
    raw_data = HTTP.get(api_url).to_s
    parsed_data = JSON.parse(raw_data)
    @result = parsed_data.fetch("result")
  end
end

get("/") do
  api_call
  erb(:index)
end

get("/:from_currency") do
  # @current_currency = params.fetch("from_currency")
  @current_currency = params[:from_currency]
  api_call
  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @current_currency = params[:from_currency]
  @to_currency = params[:to_currency]
  exchange_rate(@current_currency, @to_currency)
  erb(:to_currency)
end
