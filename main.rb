class Asset
    def initialize(value, start_year, end_year, growth_rate, income_rate, liability=nil)
        @value = value
        @start_year = start_year
        @end_year = end_year
        @growth_rate = growth_rate
        @income_rate = income_rate
        @liability = liability
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

test_asset = Asset.new(10, 1, 10, 0.05, 0.05)

loan = Liability.new(10, 1, 10, 0.03, false)

asset2 = Asset.new(10, 1, 10, 0.05, 0.05, loan)

system("clear")
puts test_asset.future_value(0)
puts test_asset.future_value(1)
#puts test_asset.liability.print_loan_interest
puts asset2.liability.print_loan_interest