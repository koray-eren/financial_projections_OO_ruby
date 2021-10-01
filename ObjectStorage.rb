require_relative("Asset")
require("tty-table")

class ObjectStorage
    attr_reader :assets

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

end