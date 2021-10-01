require_relative("Asset")
require_relative("Assumptions")
require_relative("ObjectStorage")
require("json")
require("tty-prompt")

prompt = TTY::Prompt.new

def manage_inputs
    prompt = TTY::Prompt.new
    input_menu_exit = false
    while !input_menu_exit
        system("clear")
        choices = {"Add Input" => 1, "Remove Inputs" => 2, "View Inputs" => 3, "Back" => 4}
        menu_selection = prompt.select("What would you like to do?", choices)

        #ALTERNATIVELY, JUST DISPLAY ALL CURRENT INPUTS, AND THEN CHOOSE TO ADD NEW, EDIT, OR REMOVE

        case menu_selection
        when 1
            # add input
        when 2
            # remove input
        when 3
            # assets & liabilities table
        when 4
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

test_asset = Asset.new("test", 10, 1, 10, 0.05, 0.05)

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