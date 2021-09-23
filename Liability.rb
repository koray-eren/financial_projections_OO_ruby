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