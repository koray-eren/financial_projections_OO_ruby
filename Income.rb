require_relative("Input")

class Income < Cashflow
    attr_reader :taxable
    def initialize(name, value, first_year, last_year, taxable=true)
        super(name, value, first_year, last_year)
        @taxable = taxable
    end

    def future_value(year)
        #if year outside range where cashflow exists, 0, else index by CPI
        (year < @first_year || year > last_year) ? 0 : @value * (1 + Assumptions.indexation) ** (year - 1)
    end

    def taxable_income(year)
        
    end
    # taxable_income(year)

end