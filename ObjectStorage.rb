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
                puts "added to assets"
                @assets.push(object)
            when Liability
                puts "added to liabilities"
                @liabilities.push(object)
            when Income
                puts "added to income"
                @income.push(object)
            when Expense
                puts "added to expenses"
                @expenses.push(object)
            else
                raise "Stored objects must be asset, liability, income, or expense"
        end
    end
    
    def getAssets
        return @assets
    end
end