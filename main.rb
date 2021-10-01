require_relative("Asset")
require_relative("Liability")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")
require("tty-prompt")

prompt = TTY::Prompt.new
objects = ObjectStorage.new

def manage_inputs
    prompt = TTY::Prompt.new
    input_menu_exit = false
    while !input_menu_exit
        system("clear")
        choices = {"Assets" => 1, "Liabilities" => 2, "Income" => 3, "Expenses" => 4, "Back" => 5}
        menu_selection = prompt.select("Select a category", choices)

        #ALTERNATIVELY, JUST DISPLAY ALL CURRENT INPUTS, AND THEN CHOOSE TO ADD NEW, EDIT, OR REMOVE

        case menu_selection
        #EDIT CAN JUST BE ENTER REMOVE + NEW COMBINED - I.E. YOU HAVE TO EDIT THE WHOLE THING, BUT SAVES YOU FROM CLICKING TWO OPTIONS
        when 1
            # assets
            # display all
            # select: add, remove, (edit), back
            objects.print_assets
        when 2
            # liab
            # display all
            # select: add, remove, (edit), back
        when 3
            # income
            # display all
            # select: add, remove, (edit), back
        when 4
            # expense
            # display all
            # select: add, remove, (edit), back
        when 5
            input_menu_exit = true
        end
    end
end

system("clear")

main_menu_exit = false
while !main_menu_exit
    system("clear")
    choices = {"Manage Inputs" => 1, "Cashflow Table" => 2, "Assets & Liabilties Table" => 3, "Exit" => 4}
    menu_selection = prompt.select("Welcome! What would you like to do?", choices)

    case menu_selection
    when 1
        manage_inputs
    when 2
        # cashflow table
    when 3
        #assets & liabilities table
    when 4
        main_menu_exit = true
    end
end

# name, value, first_year, growth_rate, income_rate, sale_year
# need to add handling for first_year = 0 for inputs
test_asset = Asset.new("test", 100, 0, 0.05, 0.05)
objects.store(test_asset)

test_asset2 = Asset.new("test2", 100, 0, 0.05, 0.05)
objects.store(test_asset2)

# name, value, first_year, interest_rate, deductible = false, principal_repayments = 0
test_loan = Liability.new("loan1", 1000, 1, 0.03)
objects.store(test_loan)
test_loan2 = Liability.new("loan2", 1000, 0, 0.03)
objects.store(test_loan2)
puts objects.print_assets
puts objects.print_liabilities
puts objects.print_income

exit = false

prompt.on(:keyescape) do |event|
    exit!
end

name = prompt.ask("Name:", required: true)

value = prompt.ask("Value:") do |q|
    q.validate(/\d/, "Invalid value: %{value}, must be a number")
end

# add default help: 0 == existing
first_year = prompt.slider("First Year:", min: 0, max: Assumptions.years, default: 0)
# change to sale year for asset
# for loan, start year 0 == existing loan, otherwise will be added to income
last_year = prompt.slider("Last Year:", min: 1, max: Assumptions.years, default: Assumptions.years)



# file = File.open("assets.json", "w")
# file.write(test_asset.to_json)
# file.close

# file = File.read("assets.json")
# testAsset2 = Asset.from_json(file)
# p testAsset2