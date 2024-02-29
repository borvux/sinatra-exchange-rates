require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# build the API url, including the API key in the query string
api_url = "http://api.exchangerate.host/list?access_key=#{ENV["EXCHANGERATES_KEY"]}"

# use HTTP.get to retrieve the API information
raw_data = HTTP.get(api_url)

# convert the raw request to a string
raw_data_string = raw_data.to_s

# convert the string to JSON
parsed_data = JSON.parse(raw_data_string)

get("/") do
  #get the currencies from the JSON
  @currencies_data = parsed_data.fetch("currencies")

  erb(:homepage)
end

get("/:from_currency") do
  @currencies_data = parsed_data.fetch("currencies")
  @original_currency = params.fetch("from_currency").to_s

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  # build the API url, including the API key in the query string
  api_url = "http://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGERATES_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  # use HTTP.get to retrieve the API information
  @raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  @raw_data_string = @raw_data.to_s

  # convert the string to JSON
  @parsed_data = JSON.parse(@raw_data_string)

  # get the result
  @result_data = @parsed_data.fetch("result")



  erb(:from_currency_to_currency)
end
