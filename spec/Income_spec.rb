require "../Income"
require "../Assumptions"

describe "intialization" do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9
    taxable = false

    before(:all) do
        @income = Income.new(name, value, first_year, last_year, taxable)
    end
    
    it "should initialise first_year (superclass attr) to the specified value" do
        expect(@income.name).to eq(name)
    end
    
    it "should initialise taxable to the specified value" do
        expect(@income.taxable).to eq(taxable)
    end

end

#taxable_income(year) method

describe "taxable income method" do
    name = "name"
    value = 9678
    first_year = 3
    last_year = 8

    context "taxable income" do
        before(:all) do
            @income = Income.new(name, value, first_year, last_year, taxable = true)
        end
        
        it "should return 0 for a valid year for a non-taxable income" do
            expect(@income.taxable).to eq(true)
        end
    end

    context "non-taxable income" do
        before(:all) do
            @income = Income.new(name, value, first_year, last_year, taxable = false)
        end
        
        it "should return 0 for a valid year for a non-taxable income" do
            expect(@income.taxable).to eq(false)
        end
    end


end