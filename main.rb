class Asset
    # attr_accessor
    def initialize(value, start_year, end_year, growth_rate, income_rate, liability=nil, objectStorage)
        @value = value
        @start_year = start_year
        @end_year = end_year
        @growth_rate = growth_rate
        @income_rate = income_rate
        @liability = liability
        objectStorage.add(self)
    end

    def future_value(year)
        @value * (1 + @growth_rate) ** year
    end

    def liability
        @liability
    end
end

class Assumptions
    @@indexation = 0.025
    @@years = 10
    @@tax_rate = 0.3
end

class Liability
    # do i want all of these accessible? probs not
    attr_accessor :value, :start_year, :end_year, :interest_rate, :deductible
    def initialize(value, start_year, end_year, interest_rate, deductible = true)
        @value = value
        @start_year = start_year
        @end_year = end_year
        @interest_rate = interest_rate
        @deductible = deductible
        # repayment?
    end
    def print_loan_interest
        @value * @interest_rate
    end
end

class Income
    
end

class Expense
    
end

class ObjectStorage
    def initialise
        @income = [ ]
        @expenses = [ ]
        @assets = [ ]
        @liabilities = [ ]
    end

    def add(object)
        case object.class
        when Asset
            puts "added to assets"
            assets.push(object)
        when Liability
            puts "added to liabilities"
            liabilities.push(object)
        when Income
            puts "added to income"
            income.push(object)
        when Expense
            puts "added to expenses"
            expenses.push(object)
        else
            puts "ERROR: not income, asset, expense, or liability"
        end
    end
    def getAssets
        return @assets
    end
end

objects = ObjectStorage.new

test_asset = Asset.new(10, 1, 10, 0.05, 0.05, objects)

loan = Liability.new(10, 1, 10, 0.03, false)

asset2 = Asset.new(10, 1, 10, 0.05, 0.05, loan, objects)

system("clear")
puts test_asset.future_value(0)
puts test_asset.future_value(1)
#puts test_asset.liability.print_loan_interest
puts asset2.liability.print_loan_interest

#puts objects.getAssets
puts "loan start year: #{loan.start_year}"
loan.start_year = 2
puts "changed loan start year: #{loan.start_year}"