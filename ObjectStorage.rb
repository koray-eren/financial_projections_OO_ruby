class ObjectStorage
    def initialize
        @income = []
        @expenses = []
        @assets = []
        @liabilities = []
    end

    def store(object)
        puts object.class == Asset
        case object.class
            when Asset
                puts "added to assets"
                assets.push(object)
            # when object.class == Liability
            #     puts "added to liabilities"
            #     liabilities.push(object)
            # when Income
            #     puts "added to income"
            #     income.push(object)
            # when Expense
            #     puts "added to expenses"
            #     expenses.push(object)
            else
                raise "Stored objects must be asset, liability, income, or expense"
        end
    end
    
    def getAssets
        return @assets
    end
end