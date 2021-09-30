require "../Cashflow"
require "../Assumptions"

describe "Cashflow" do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9

    before(:all) do
        @cashflow = Cashflow.new(name, value, first_year, last_year)
    end
    
    it "should initialise first_year to the specified value" do
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