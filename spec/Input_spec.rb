require "../Input"
require "../Assumptions"

describe Input do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9

    before(:all) do
        @input = Input.new(name, value, first_year, last_year)
    end
    
    it "should initialise first_year to the specified value" do
        expect(@input.name).to eq(name)
        ∂
        expect(@input.first_year).to eq(first_year)
        expect(@input.last_year).to eq(last_year)
    end
    
    it "should initialise value attribute to the specified value" do
        expect(@input.value).to eq(value)
    end
    
    it "should initialise first_year to the specified value" do
        expect(@input.first_year).to eq(first_year)
    end
    
    it "should initialise last_year to the specified value" do
        expect(@input.last_year).to eq(last_year)
    end

    it "should initialise last_year to the length of the projections if no value is provided" do
        @input_without_last_year = Input.new(name, value, first_year)
        expect(@input_without_last_year.last_year).to eq(Assumptions.years)
    end
end