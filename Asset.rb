class Asset
    # attr_accessor
    def initialize(value, start_year, end_year, growth_rate, income_rate, liability=nil, objectStorage=nil)
        @value = value
        @start_year = start_year
        @end_year = end_year
        @growth_rate = growth_rate
        @income_rate = income_rate
        @liability = liability
        objectStorage != nil ? objectStorage.store(self) : nil
    end

    def future_value(year)
        @value * (1 + @growth_rate) ** year
    end
    
    def to_json
        {   'value' => @value,
            'start_year' => @start_year,
            'end_year' => @end_year,
            'growth_rate' => @growth_rate,
            'income_rate' => @income_rate }.to_json
    end

    def self.from_json(hash)
        self.new(hash['value'], hash['start_year'], hash['end_year'], hash['growth_rate'], hash['income_rate'] )
    end

    # associate_liability
end