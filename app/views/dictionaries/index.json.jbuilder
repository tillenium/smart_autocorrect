json.array!(@dictionaries) do |dictionary|
  json.extract! dictionary, :id
  json.url dictionary_url(dictionary, format: :json)
end
