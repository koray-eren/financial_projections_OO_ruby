require_relative("Asset")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")

# objects = ObjectStorage.new

test_asset = Asset.new(10, 1, 10, 0.05, 0.05)

# loan = Liability.new(10, 1, 10, 0.03, false)
# asset2 = Asset.new(10, 1, 10, 0.05, 0.05, loan, objects)

#seperate file for each type (asset, liabilities, income, expenses)
file = File.open("assets.json", "w")

file.write(test_asset.to_json)
file.close

file = File.read("assets.json")

testAsset2 = Asset.from_json(file)
p testAsset2

puts "\n++++++++++++++++++++++++"
puts testAsset2.future_value(0)
puts testAsset2.future_value(1)

# system("clear")
# puts test_asset.future_value(1)
# puts test_asset.liability.print_loan_interest
# puts asset2.liability.print_loan_interest

# puts objects.getAssets
# puts "loan start year: #{loan.start_year}"
# loan.start_year = 2
# puts "changed loan start year: #{loan.start_year}"