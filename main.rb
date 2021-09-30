require_relative("Asset")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")
require("tty-prompt")

system("clear")
test_asset = Asset.new("test", 10, 1, 10, 0.05, 0.05)

prompt = TTY::Prompt.new
exit = false

prompt.on(:keyescape) do |event|
    exit!
end

name = prompt.ask("Name:")

value = prompt.ask("Value:") do |q|
    q.validate(/\d/, "Invalid value: %{value}, must be a number")
end

first_year = prompt.slider("First Year:", min: 1, max: Assumptions.years, default: 1)
# change to sale year for asset
last_year = prompt.slider("Last Year:", min: 1, max: Assumptions.years, default: Assumptions.years)


# file = File.open("assets.json", "w")
# file.write(test_asset.to_json)
# file.close

# file = File.read("assets.json")
# testAsset2 = Asset.from_json(file)
# p testAsset2