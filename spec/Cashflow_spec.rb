require "../Cashflow"
require "../Assumptions"

describe "intialization" do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9

    before(:all) do
        @cashflow = Cashflow.new(name, value, first_year, last_year)
    end
    
    it "should initialise first_year (superclass attr) to the specified value" do
        expect(@cashflow.name).to eq(name)
    end
    
    it "should initialise last_year to the specified value" do
        expect(@cashflow.last_year).to eq(last_year)
    end

    it "should initialise last_year to the length of the projections if no value is provided" do
        @cashflow_without_last_year = Input.new(name, value, first_year)
        expect(@cashflow_without_last_year.last_year).to eq(Assumptions.years)
    end
end

describe "future value method" do
    name = "name"
    value = 43267
    first_year = 2
    last_year = 9

    before(:all) do
        @cashflow = Cashflow.new(name, value, first_year, last_year)
    end

    it "should index the value by CPI" do
        year = 3
        expect(@cashflow.future_value(year) ).to eq(value * (1 + Assumptions.indexation) ** (year - 1) )
    end

    it "should return 0 if provided year is before first_year" do
        year = 1
        expect(@cashflow.future_value(year) ).to eq(0)
    end
    
    it "should return 0 if provided year is after last_year" do
        year = 10
        expect(@cashflow.future_value(year) ).to eq(0)
    end
end