class Liability
    # do i want all of these accessible? probs not
    attr_accessor :value, :first_year, :last_year, :interest_rate, :deductible
    
    def initialize(name, value, first_year, last_year, interest_rate, deductible = true, principal_repayments = 0)
        super
        @interest_rate = interest_rate
        @deductible = deductible
        @principal_repayments = principal_repayments
    end

    def print_loan_interest
        @value * @interest_rate
    end

    def future_balance(year)
        
        # future value = value - (years_that_have_passed * principal_repayments)
    end
end