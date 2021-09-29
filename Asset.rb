require_relative("Input")

class Asset < Input
    # attr_accessor
    def initialize(name, value, first_year, last_year, growth_rate, income_rate)
        super(name, value, first_year, last_year)
        @growth_rate = growth_rate
        @income_rate = income_rate
    end

    def future_value(year)
        @value * (1 + @growth_rate) ** year
    end
    
    def to_json
        {   'value' => @value,
            'first_year' => @first_year,
            'last_year' => @last_year,
            'growth_rate' => @growth_rate,
            'income_rate' => @income_rate }.to_json
    end

    def self.from_json(json_file_path)
        hash = JSON.parse(json_file_path)
        self.new(hash['value'], hash['first_year'], hash['last_year'], hash['growth_rate'], hash['income_rate'] )
    end

end