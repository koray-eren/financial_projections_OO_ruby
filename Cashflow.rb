require_relative("Input")

class Cashflow < Input
    attr_reader :last_year
    def initialize(name, value, first_year, last_year)
        super(name, value, first_year)
        @last_year = last_year
    end

    def future_value(year)
        #if year outside range where cashflow exists, 0, else index by CPI
        (year < @first_year || year > last_year) ? 0 : @value * (1 + Assumptions.indexation) ** (year - 1)
    end

end