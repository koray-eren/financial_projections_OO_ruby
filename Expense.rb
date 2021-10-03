require_relative("Cashflow")

class Expense < Cashflow
    attr_reader :deductible
    def initialize(name, value, first_year, last_year, deductible=false)
        super(name, value, first_year, last_year)
        @deductible = deductible
    end

    def deductible_expense(year)
        @deductible ? future_value(year) : 0
    end

    def to_array
        [@name, @value, @first_year, @last_year, @deductible]
    end

    def to_hash
        {   'name' => @name,
            'value' => @value,
            'first_year' => @first_year,
            'last_year' => @last_year,
            'deductible' => @deductible }
    end

end