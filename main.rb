require_relative("Output")
require_relative("Asset")
require_relative("Liability")
require_relative("Income")
require_relative("Expense")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")
require("tty-prompt")
require("colorize")

prompt = TTY::Prompt.new
objects = ObjectStorage.new
output = Output.new(objects)

test_asset = Asset.new("asset1", 1000, 0, 0.05, 0.05)
test_asset2 = Asset.new("asset2", 1000, 5, 0.05, 0.05)
objects.store(test_asset)
objects.store(test_asset2)

test_loan = Liability.new("loan1", 1000, 1, 0.03)
test_loan2 = Liability.new("loan2", 1000, 0, 0.03)
test_loan3 = Liability.new("loan3", 500, 5, 0.03)
objects.store(test_loan)
objects.store(test_loan2)
objects.store(test_loan3)

income1 = Income.new("income 1", 4000, 0, 10, true)
income2 = Income.new("income 2", 2000, 4, 8, false)
objects.store(income1)
objects.store(income2)

expense1 = Expense.new("expense 1", 1000, 0, 10, true)
expense2 = Expense.new("expense 2", 3000, 2, 9, false)
objects.store(expense1)
objects.store(expense2)

system("clear")

main_menu_exit = false
while !main_menu_exit
    system("clear")
    choices = {"Manage Inputs" => 1, "Cashflow Table" => 2, "Assets & Liabilities Table" => 3, "Exit" => 4}
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

# INLCUDE ERROR HANDLING FOR JSON PART

# R19: BASH SCRIPT OR PACKAGE FOR USE AS A MODULE OR DEPENDENCY

objects.save_all_inputs_to_json("./scenario1")

# file = File.read("assets.json")
# testAsset2 = Asset.from_json(file)
# p testAsset2