require_relative("../Asset.rb")
require_relative("../Assumptions.rb")

describe "initialization" do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9
    growth_rate = 0.05
    income_rate = 0.03
    
    before(:all) do
        @asset = Asset.new(name, value, first_year, growth_rate, income_rate)
    end
    
    it "should initialise growth_rate to the specified value" do
        expect(@asset.growth_rate).to eq(growth_rate)
    end
    
    it "should initialise income_rate to the specified value" do
        expect(@asset.income_rate).to eq(income_rate)
    end

    it "should initialise name (super class attribute) to the specified value" do
        expect(@asset.name).to eq(name)
    end
end

describe "future value method" do
    name = "name"
    value = 1000
    first_year = 1
    growth_rate = 0.05
    income_rate = 0.03

    before(:all) do
        @asset = Asset.new(name, value, first_year, growth_rate, income_rate)
    end

    it "should not apply any growth in year 1" do
        expect(@asset.future_value(1) ).to eq(value)
    end

    it "should apply the relevant growth rate to calculate the future value of an asset" do
        expect(@asset.future_value(2) ).to eq(value * (1 + growth_rate) )
    end
    
    it "should compound annually to calculate future value of an asset " do
        expect(@asset.future_value(3) ).to eq(value * (1 + growth_rate) * (1 + growth_rate) )
    end
    
    it "should return 0 if provided year is before first_year" do
        @asset2 = Asset.new(name, value, 2, growth_rate, income_rate)
        expect(@asset2.future_value(1) ).to eq(0)
    end

    it "should return 0 if provided year is after sale_year" do
        @asset2 = Asset.new(name, value, 2, growth_rate, income_rate, sale_year=8)
        expect(@asset2.future_value(10) ).to eq(0)
    end
    
    it "should return 0 if provided year is same as sale_year" do
        @asset2 = Asset.new(name, value, 2, growth_rate, income_rate, sale_year=8)
        expect(@asset2.future_value(8) ).to eq(0)
    end

    it "should index the starting value of the asset by CPI if first_year is not year 1" do
        @asset2 = Asset.new(name, value, 2, growth_rate, income_rate)
        expect(@asset2.future_value(2) ).to eq(value * (1 + Assumptions.indexation) )
    end

    it "should return same initial value for first_year = 0 and first_year = 1" do
        @asset2 = Asset.new(name, value, 1, growth_rate, income_rate)
        expect(@asset2.future_value(1) ).to eq(@asset.future_value(1) )
    end

    it "should return same future value for first_year = 0 and first_year = 1" do
        @asset2 = Asset.new(name, value, 1, growth_rate, income_rate)
        expect(@asset2.future_value(2) ).to eq(@asset.future_value(2) )
    end
end

describe "future year income" do
    name = "name"
    value = 1000
    first_year = 2
    growth_rate = 0.05
    income_rate = 0.03

    before(:all) do
        @asset = Asset.new(name, value, first_year, growth_rate, income_rate)
    end

    it "should return the value of the asset (for the relevant year) multiplied by the income rate" do
        year = 2
        expect(@asset.year_n_income(year) ).to eq(@asset.future_value(year) * @asset.income_rate )
    end

    it "should return 0 for a year where the asset does not exist" do
        year = 1
        expect(@asset.year_n_income(year) ).to eq(0)
    end
end