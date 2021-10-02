require_relative("Output")
require_relative("Asset")
require_relative("Liability")
require_relative("Income")
require_relative("Expense")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")
require("tty-prompt")

prompt = TTY::Prompt.new
objects = ObjectStorage.new
output = Output.new(objects)

test_asset = Asset.new("asset1", 1000, 0, 0.05, 0.05)
objects.store(test_asset)
test_asset2 = Asset.new("asset2", 1000, 5, 0.05, 0.05)
objects.store(test_asset2)
test_loan = Liability.new("loan1", 1000, 1, 0.03)
objects.store(test_loan)
test_loan2 = Liability.new("loan2", 1000, 0, 0.03)
objects.store(test_loan2)

system("clear")

main_menu_exit = false
while !main_menu_exit
    system("clear")
    choices = {"Manage Inputs" => 1, "Cashflow Table" => 2, "Assets & Liabilties Table" => 3, "Exit" => 4}
    menu_selection = prompt.select("Welcome! What would you like to do?", choices, cycle: true)

    case menu_selection
    when 1
        objects.manage_inputs_menu
    when 2
        output.print_cashflow
    when 3
        output.print_assets_liabilities
    when 4
        main_menu_exit = true
    end
end


# file = File.open("assets.json", "w")
# file.write(test_asset.to_json)
# file.close

# file = File.read("assets.json")
# testAsset2 = Asset.from_json(file)
# p testAsset2