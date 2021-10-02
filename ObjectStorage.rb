require_relative("Asset")
require("tty-table")

class ObjectStorage
    attr_reader :assets, :liabilities, :income, :expenses

    def initialize
        @income = []
        @expenses = []
        @assets = []
        @liabilities = []
    end

    def store(object)
        case object
            when Asset
                @assets.push(object)
            when Liability
                @liabilities.push(object)
            when Income
                @income.push(object)
            when Expense
                @expenses.push(object)
            else
                raise "Stored objects must be asset, liability, income, or expense"
        end
    end
    
    def print_inputs(array, header)
        rows = []
        i = 1
        for item in array do
            rows << item.to_array.unshift(i)
            i += 1
        end
        table = TTY::Table.new(header, rows)
        puts table.render(:unicode, alignment: [:center], padding: [0,1] )
    end

    def print_assets
        header = ["No.", "Name", "Value", "First Year", "Growth Rate", "Income Rate", "Sale Year"]
        print_inputs(@assets, header)
    end

    def print_liabilities
        header = ["No.", "Name", "Value", "First Year", "Interest Rate", "Deductible", "Principal Repayments"]
        print_inputs(@liabilities, header)
    end

    def print_income
        header = ["No.", "Name", "Value", "First Year", "Last Year", "Taxable"]
        print_inputs(@income, header)
    end
    
    def print_expenses
        header = ["No.", "Name", "Value", "First Year", "Last Year", "Deductible"]
        print_inputs(@expenses, header)
    end

    def add_asset
        system("clear")
        puts "New Asset\n---------"
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
    
        sale_year = prompt.slider("Sale Year (optional, 0 = none):", min: 0, max: Assumptions.years, default: 0)
    
        sale_year == 0 ? sale_year = nil : nil
    
        store(Asset.new(name, value, first_year, growth_rate, income_rate, sale_year) )
        
    end
    
    def add_liability
        system("clear")
        puts "New Liability\n---------"
        prompt = TTY::Prompt.new
        name = prompt.ask("Name:", required: true)
    
        value = prompt.ask("Value:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
        end
    
        first_year = prompt.slider("First Year (0 = existing):", min: 0, max: Assumptions.years, default: 0)
    
        interest_rate = prompt.ask("Interest Rate (Decimal: 0.05 = 5% per annum) :") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.default(0.05)
        end
    
        deductible = prompt.yes?("Deductible Loan?") do |q|
            q.default(false)
        end
    
        principal_repayments = prompt.ask("Principal Repayments Per Annum (optional):") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.default(0)
        end
        
        store(Liability.new(name, value, first_year, interest_rate, deductible, principal_repayments) )
        
    end
    
    def add_income
        system("clear")
        puts "New Income\n---------"
        prompt = TTY::Prompt.new
        name = prompt.ask("Name:", required: true)
    
        value = prompt.ask("Value:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
        end
    
        first_year = prompt.slider("First Year:", min: 1, max: Assumptions.years, default: 1)
        last_year = prompt.slider("Last Year:", min: 1, max: Assumptions.years, default: Assumptions.years)
        taxable = prompt.yes?("Taxable Income?", default: true)   
         
        store(Income.new(name, value, first_year, last_year, taxable) )
        
    end
    
    def add_expense
        system("clear")
        puts "New Expense\n---------"
        prompt = TTY::Prompt.new
        name = prompt.ask("Name:", required: true)
    
        value = prompt.ask("Value:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
        end
    
        first_year = prompt.slider("First Year:", min: 1, max: Assumptions.years, default: 1)
        last_year = prompt.slider("Last Year:", min: 1, max: Assumptions.years, default: Assumptions.years)
        deductible = prompt.yes?("Deductible Expense?", default: false)
         
        store(Expense.new(name, value, first_year, last_year, deductible) )
    end    


    def remove_asset
        system("clear")
        puts "Remove Asset\n---------"
        puts print_assets
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select an asset to remove:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@assets.length}")
            q.convert(:int)
        end
        @assets.delete_at(index_to_remove - 1)
    end
    
    def remove_liability
        system("clear")
        puts "Remove Liability\n---------"
        puts print_liabilities
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select a liability to remove:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@liabilities.length}")
            q.convert(:int)
        end
        @liabilities.delete_at(index_to_remove - 1)
    end
    
    def remove_income
        system("clear")
        puts "Remove Income\n---------"
        puts print_income
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select an income to remove:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@income.length}")
            q.convert(:int)
        end
        @income.delete_at(index_to_remove - 1)
    end
    
    def remove_expense
        system("clear")
        puts "Remove Expense\n---------"
        puts print_expenses
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select an expense to remove:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@expenses.length}")
            q.convert(:int)
        end
        @expenses.delete_at(index_to_remove - 1)
    end
    

    def edit_asset
        system("clear")
        puts "Edit Asset\n---------"
        puts print_assets
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select an asset to edit:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@assets.length}")
            q.convert(:int)
        end
        @assets.delete_at(index_to_remove - 1)
        add_asset
    end
    
    def edit_liability
        system("clear")
        puts "Edit Liability\n---------"
        puts print_liabilities
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select a liability to edit:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@liabilities.length}")
            q.convert(:int)
        end
        @liabilities.delete_at(index_to_remove - 1)
        add_liability
    end
    
    def edit_income
        system("clear")
        puts "Edit Income\n---------"
        puts print_income
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select an income to edit:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@income.length}")
            q.convert(:int)
        end
        @income.delete_at(index_to_remove - 1)
        add_income
    end
    
    def edit_expense
        system("clear")
        puts "Edit Expense\n---------"
        puts print_expenses
        prompt = TTY::Prompt.new
        index_to_remove = prompt.ask("Select an expense to edit:") do |q|
            q.validate(/\d/, "Invalid value: %{value}, must be a number")
            q.in("1-#{@expenses.length}")
            q.convert(:int)
        end
        @expenses.delete_at(index_to_remove - 1)
        add_expense
    end
    

    def manage_assets
        manage_assets_exit = false
        while !manage_assets_exit
            prompt = TTY::Prompt.new
            system("clear")
            puts "ASSETS\n---------"
            puts print_assets
            choices = [
                { key: "a", name: "add a new asset", value: :add },
                { key: "r", name: "remove an asset", value: :remove },
                { key: "e", name: "edit an asset", value: :edit },
                { key: "q", name: "quit to previous menu ", value: :quit } ]
            @assets.size == 0 ? (choices.delete_at(2); choices.delete_at(1)) : nil
            puts "a - add,  #{@assets.size == 0 ? nil : "r - remove,  e - edit,  "}q - quit"
            selection = prompt.expand("Select an option", choices)
        
            case selection
            when :add
                add_asset
            when :remove
                remove_asset
            when :edit
                edit_asset
            when :quit
                manage_assets_exit = true
            end
        end
    end
    
    def manage_liabilities
        manage_liabilities_exit = false
        while !manage_liabilities_exit
            prompt = TTY::Prompt.new
            system("clear")
            puts "LIABILITIES\n---------"
            puts print_liabilities
            choices = [
                { key: "a", name: "add a new liability", value: :add },
                { key: "r", name: "remove a liability", value: :remove },
                { key: "e", name: "edit a liability", value: :edit },
                { key: "q", name: "quit to previous menu ", value: :quit } ]
            @liabilities.size == 0 ? (choices.delete_at(2); choices.delete_at(1)) : nil
            puts "a - add,  #{@liabilities.size == 0 ? nil : "r - remove,  e - edit,  "}q - quit"
            selection = prompt.expand("Select an option", choices)
        
            case selection
            when :add
                add_liability
            when :remove
                remove_liability
            when :edit
                edit_liability
            when :quit
                manage_liabilities_exit = true
            end
        end
    end
    
    def manage_income
        manage_income_exit = false
        while !manage_income_exit
            prompt = TTY::Prompt.new
            system("clear")
            puts "INCOME\n---------"
            puts print_income
            choices = [
                { key: "a", name: "add a new income", value: :add },
                { key: "r", name: "remove an income", value: :remove },
                { key: "e", name: "edit an income", value: :edit },
                { key: "q", name: "quit to previous menu ", value: :quit } ]
            @income.size == 0 ? (choices.delete_at(2); choices.delete_at(1)) : nil
            puts "a - add,  #{@income.size == 0 ? nil : "r - remove,  e - edit,  "}q - quit"
            selection = prompt.expand("Select an option", choices)
        
            case selection
            when :add
                add_income
            when :remove
                remove_income
            when :edit
                edit_income
            when :quit
                manage_income_exit = true
            end
        end
    end
    
    def manage_expenses
        manage_expenses_exit = false
        while !manage_expenses_exit
            prompt = TTY::Prompt.new
            system("clear")
            puts "EXPENSES\n---------"
            puts print_expenses
            choices = [
                { key: "a", name: "add a new expense", value: :add },
                { key: "r", name: "remove an expense", value: :remove },
                { key: "e", name: "edit an expense", value: :edit },
                { key: "q", name: "quit to previous menu ", value: :quit } ]
            @expenses.size == 0 ? (choices.delete_at(2); choices.delete_at(1)) : nil
            puts "a - add,  #{@expenses.size == 0 ? nil : "r - remove,  e - edit,  "}q - quit"
            selection = prompt.expand("Select an option", choices)
        
            case selection
            when :add
                add_expense
            when :remove
                remove_expense
            when :edit
                edit_expense
            when :quit
                manage_expenses_exit = true
            end
        end
    end

    def manage_inputs_menu
        prompt = TTY::Prompt.new
        input_menu_exit = false
        while !input_menu_exit
            system("clear")
            choices = {"Assets" => 1, "Liabilities" => 2, "Income" => 3, "Expenses" => 4, "Back" => 5}
            menu_selection = prompt.select("Select a category", choices, cycle: true)
    
            case menu_selection
            when 1 # assets
                manage_assets
            when 2 # liabilities
                manage_liabilities
            when 3 # income
                manage_income
            when 4 # expense
                manage_expenses
            when 5
                input_menu_exit = true
            end
        end
    end
    
end