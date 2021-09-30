require_relative("Input")

class Asset < Input
    attr_reader :growth_rate, :income_rate, :sale_year
    def initialize(name, value, first_year, growth_rate, income_rate, sale_year = nil)
        super(name, value, first_year)
        @growth_rate = growth_rate
        @income_rate = income_rate
        @sale_year = sale_year
    end

    def future_value(year)        
        # if year is outside the range where the asset exists
        if year < @first_year || (sale_year != nil && year >= sale_year)
            return 0
        # if asset is purchased in a future year
        elsif @first_year > 1
            indexed_value = @value * (1 + Assumptions.indexation) ** (@first_year - 1)
            indexed_value * (1 + @growth_rate) ** (year - first_year)
        else
            @value * (1 + @growth_rate) ** (year - 1)
        end
    end

    def year_n_income(year)
        future_value(year) * income_rate
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