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
require("fileutils")

prompt = TTY::Prompt.new
objects = ObjectStorage.new
output = Output.new(objects)

intialization_parameters = ARGV
scenario_name = (ARGV.length == 0 ? "scenario1" : ARGV[0].to_s)
puts ARGV[0].to_s

File.directory?("./#{scenario_name}") ? nil : FileUtils.mkdir("./#{scenario_name}")
begin
    objects.load_all_inputs_from_json("./#{scenario_name}")
rescue => exception
    prompt.keypress("Scenario not found, creating new scenario #{scenario_name}. Press space or return to continue.", keys: [:space, :return])
end

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

# scenario_name = prompt.yes?("Save your inputs?") ? prompt.ask("Scenario name: ", default: "scenario1") : nil
# scenario_name != nil ? objects.save_all_inputs_to_json("./#{scenario_name}") : nil
prompt.yes?("Save your inputs?") ? objects.save_all_inputs_to_json("./#{scenario_name}") : nil

# file = File.read("assets.json")
# testAsset2 = Asset.from_json(file)
# p testAsset2