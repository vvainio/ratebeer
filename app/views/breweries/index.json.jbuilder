json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year, :active
end
