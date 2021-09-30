require_relative("Input")

class Cashflow < Input
    attr_reader :last_year
    def initialize(name, value, first_year, last_year)
        super(name, value, first_year)
        @last_year = last_year
    end

    def future_value(year)        
        
    end

end