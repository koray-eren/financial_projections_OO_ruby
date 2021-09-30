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

end