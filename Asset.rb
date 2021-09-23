class Asset
    # attr_accessor
    def initialize(value, start_year, end_year, growth_rate, income_rate, liability=nil, objectStorage)
        @value = value
        @start_year = start_year
        @end_year = end_year
        @growth_rate = growth_rate
        @income_rate = income_rate
        @liability = liability
        objectStorage.store(self)
    end

    def future_value(year)
        @value * (1 + @growth_rate) ** year
    end

    # associate_liability
end