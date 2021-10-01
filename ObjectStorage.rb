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
        for item in array do
            rows << item.to_array
        end
        table = TTY::Table.new(header, rows)
        puts table.render(:unicode, alignment: [:center], padding: [0,1] )
    end

    def print_assets
        header = ["Name", "Value", "First Year", "Growth Rate", "Income Rate", "Sale Year"]
        print_inputs(@assets, header)
    end

    def print_liabilities
        header = ["Name", "Value", "First Year", "Interest Rate", "Deductible", "Principal Repayments"]
        print_inputs(@liabilities, header)
    end

    def print_liabilities
        header = ["Name", "Value", "First Year", "Interest Rate", "Deductible", "Principal Repayments"]
        print_inputs(@liabilities, header)
    end

end