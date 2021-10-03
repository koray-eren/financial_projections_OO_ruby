class Liability < Input
    # do i want all of these accessible? probs not
    attr_reader :interest_rate, :deductible, :principal_repayments
    
    def initialize(name, value, first_year, interest_rate, deductible = false, principal_repayments = 0)
        super(name, value, first_year)
        @interest_rate = interest_rate
        @deductible = deductible
        @principal_repayments = principal_repayments
    end

    def interest_payable(year)
        future_value(year) * @interest_rate
    end

    def future_value(year)
        if first_year > 1
            commencement_value = @value * (1 + Assumptions.indexation) ** (@first_year - 1)
        else
            commencement_value = @value
        end
        future_value = commencement_value - ((year - @first_year) * @principal_repayments)
        future_value < 0? 0 : future_value
    end

    def principal_repayment(year)
        future_value(year) == 0 ? 0 : (future_value(year) > principal_repayments ? principal_repayments : future_value(year) )
    end

    def to_array
        [@name, @value, @first_year, @interest_rate, @deductible, @principal_repayments]
    end

    def to_hash
        {   'name' => @name,
            'value' => @value,
            'first_year' => @first_year,
            'interest_rate' => @interest_rate,
            'deductible' => @deductible,
            'principal_repayments' => @principal_repayments }
    end

end