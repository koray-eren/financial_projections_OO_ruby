require "../expense"
require "../Assumptions"

describe "intialization" do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9
    deductible = true

    before(:all) do
        @expense = Expense.new(name, value, first_year, last_year, deductible)
    end
        
    it "should initialise deductible to the specified value" do
        expect(@expense.deductible).to eq(deductible)
    end

    it "should initialise deductible to false if not specified" do
        @expense2 = Expense.new(name, value, first_year, last_year)
        expect(@expense2.deductible).to eq(false)
    end

end

describe "deductible expense method" do
    name = "name"
    value = 7432
    first_year = 3
    last_year = 8

    context "deductible expense" do
        before(:all) do
            @expense = Expense.new(name, value, first_year, last_year, deductible = true)
        end
        
        it "should return indexed expense amount for a valid year" do
            year = 3
            expect(@expense.deductible_expense(year) ).to eq(@expense.future_value(year))
        end

        it "should return indexed expense amount for a valid year" do
            expect(@expense.deductible_expense(2) ).to eq(0)
        end
    end

    context "non-deductible expense" do
        before(:all) do
            @expense = Expense.new(name, value, first_year, last_year, deductible = false)
        end
        
        it "should return 0 for a valid year" do
            expect(@expense.deductible_expense(3)).to eq(0)
        end

        it "should return 0 for a non-valid year" do
            expect(@expense.deductible_expense(1)).to eq(0)
        end
    end
end