require_relative("Asset")
require_relative("Liability")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")
require("tty-prompt")

prompt = TTY::Prompt.new
objects = ObjectStorage.new

test_asset = Asset.new("test", 100, 0, 0.05, 0.05)
objects.store(test_asset)
test_asset2 = Asset.new("test2", 100, 0, 0.05, 0.05)
objects.store(test_asset2)
test_loan = Liability.new("loan1", 1000, 1, 0.03)
objects.store(test_loan)
test_loan2 = Liability.new("loan2", 1000, 0, 0.03)
objects.store(test_loan2)

def add_asset(objects)
    prompt = TTY::Prompt.new
    name = prompt.ask("Name:", required: true)

    value = prompt.ask("Value:") do |q|
        q.validate(/\d/, "Invalid value: %{value}, must be a number")
    end

    first_year = prompt.slider("First Year (0 = existing):", min: 0, max: Assumptions.years, default: 0)

    growth_rate = prompt.ask("Growth Rate (Decimal: 0.05 = 5% per annum) :") do |q|
        q.validate(/\d/, "Invalid value: %{value}, must be a number")
        q.default(0.05)
    end

    income_rate = prompt.ask("Income Rate (Decimal: 0.05 = 5% per annum) :") do |q|
        q.validate(/\d/, "Invalid value: %{value}, must be a number")
        q.default(0.04)
    end

    sale_year = prompt.slider("First Year (optional, 0 = none):", min: 0, max: Assumptions.years, default: 0)

    sale_year == 0 ? sale_year = nil : nil

    objects.store(Asset.new(name, value, first_year, growth_rate, income_rate, sale_year) )
    
end

def manage_assets(objects)
    prompt = TTY::Prompt.new
    puts objects.print_assets
    choices = [
        { key: "a", name: "add a new asset", value: :add },
        { key: "r", name: "remove an asset", value: :remove },
        { key: "e", name: "edit an asset", value: :edit },
        { key: "q", name: "quit to previous menu ", value: :quit } ]
    puts "a - add,  r - remove,  e - edit,  q - quit"
    selection = prompt.expand("Select an option", choices)

    case selection
    when :add
        add_asset(objects)
    when :remove
        # select an asset
        # remove asset process
        puts "REMOVE"
        sleep(2)
    when :edit
        # select one
        # edit process (remove + new)
        puts "EDIT"
        sleep(2)
    end
end

def manage_inputs(objects)
    prompt = TTY::Prompt.new
    input_menu_exit = false
    while !input_menu_exit
        system("clear")
        choices = {"Assets" => 1, "Liabilities" => 2, "Income" => 3, "Expenses" => 4, "Back" => 5}
        menu_selection = prompt.select("Select a category", choices)

        #ALTERNATIVELY, JUST DISPLAY ALL CURRENT INPUTS, AND THEN CHOOSE TO ADD NEW, EDIT, OR REMOVE

        case menu_selection
        #EDIT CAN JUST BE ENTER REMOVE + NEW COMBINED - I.E. YOU HAVE TO EDIT THE WHOLE THING, BUT SAVES YOU FROM CLICKING TWO OPTIONS
        when 1 # assets
            manage_assets(objects)
        when 2 # liabilities
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
        manage_inputs(objects)
    when 2
        # cashflow table
    when 3
        #assets & liabilities table
    when 4
        main_menu_exit = true
    end
end

exit = false

prompt.on(:keyescape) do |event|
    exit!
end

name = prompt.ask("Name:", required: true)

value = prompt.ask("Value:") do |q|
    q.validate(/\d/, "Invalid value: %{value}, must be a number")
end

# add default help: 0 == existing
puts "TEST"
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