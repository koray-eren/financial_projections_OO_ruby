class Input
    attr_reader :name, :value, :first_year, :last_year

    def initialize(name, value, first_year, last_year=Assumptions.years)
        @name = name
        @value = value
        @first_year = first_year
        @last_year = last_year
    end

end