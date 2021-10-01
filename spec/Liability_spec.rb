require_relative("../Liability.rb")
# require_relative("../Assumptions.rb")

describe "initialization" do
    name = "name"
    value = 1000
    first_year = 2
    last_year = 9
    interest_rate = 0.03
    deductible = false
    principal_repayments = 500
    
    context "optional arguments specified" do
        before(:all) do
            @liability = Liability.new(name, value, first_year, interest_rate, deductible, principal_repayments)
        end
        
        it "should initialise interest_rate to the specified value" do
            expect(@liability.interest_rate).to eq(interest_rate)
        end
    
        it "should initialise deductible to the specified value" do
            expect(@liability.deductible).to eq(deductible)
        end
        
        it "should initialise principal_repayments to the specified value" do
            expect(@liability.principal_repayments).to eq(principal_repayments)
        end
    end    

    context "optional arguments not specified" do
        before(:all) do
            @liability = Liability.new(name, value, first_year, interest_rate)
        end
        
        it "should initialise principal_repayments to 0" do
            expect(@liability.principal_repayments).to eq(0)
        end

        it "should initialise deductible to false" do
            expect(@liability.deductible).to eq(false)
        end
    end

end

describe "future value" do
    name = "name"
    first_year = 1
    interest_rate = 0.03
    deductible = false
        
    context "liability with no principal repayments" do
        it "should not reduce the value of the loan in future years" do
            @liability = Liability.new(name, value=2000, first_year, interest_rate, deductible, principal_repayments=0)
            expect(@liability.future_value(4) ).to eq(2000)
        end
    end

    context "liability with principal repayments" do
        before(:all) do
            @liability = Liability.new(name, value=2000, first_year, interest_rate, deductible, principal_repayments=500)
        end

        it "should reduce the value of the loan by the principal repayment amount each year" do
            expect(@liability.future_value(4) ).to eq(500)
        end

        it "should return 0 in the year immediately after the balance being completely repaid" do
            expect(@liability.future_value(5) ).to eq(0)
        end

        it "should return 0 for future years after balance being completely repaid" do
            expect(@liability.future_value(7) ).to eq(0)
        end
        
        it "should not repay more than the available balance for a given year" do
            @liability2 = Liability.new(name, value=1800, first_year, interest_rate, deductible, principal_repayments=500)
            expect(@liability2.future_value(5) ).to eq(0)
        end
    end

    context "liability that commences in a future year" do
        before(:all) do
            @liability = Liability.new(name, value=2000, first_year=3, interest_rate, deductible, principal_repayments=500)
        end

        it "should index the commencement value of the loan by CPI" do
            expect(@liability.future_value(3) ).to eq(2000 * (1 + Assumptions.indexation) ** 2 )
        end

        #wrong context
        it "should not index the loan value where it commences in year 1" do
            # expect(@liability.future_value(3) ).to eq(value * (1+Assumptions.indexation) ** 2 )
        end

    end
end

# get year's repayment (i.e. to account for rem. bal. < annual repay)
describe "principal_repayment(year)" do
    name = "name"
    first_year = 1
    interest_rate = 0.03
    deductible = false
        
    context "liability with no principal repayments" do
        it "should return 0" do
            @liability = Liability.new(name, value=2000, first_year, interest_rate, deductible, principal_repayments=0)
            expect(@liability.principal_repayment(4) ).to eq(0)
        end
    end

    context "liability with principal repayments" do
        before(:all) do
            @liability = Liability.new(name, value=1800, first_year, interest_rate, deductible, principal_repayments=500)
        end

        it "should return principal_repayments where it is equal to future value" do
            expect(@liability.principal_repayment(3) ).to eq(500)
        end

        it "should return loan balance where it is less than principal repayments" do
            expect(@liability.principal_repayment(4) ).to eq(300)
        end

        it "should return 0 where there is no loan balance" do
            expect(@liability.principal_repayment(5) ).to eq(0)
        end
    end

end


describe "interest_payable" do
    name = "name"
    value = 2000
    first_year = 1
    last_year = 9
    interest_rate = 0.03
    deductible = false
    principal_repayments = 500
    
    before(:all) do
        @liability = Liability.new(name, value, first_year, interest_rate, deductible, principal_repayments)
    end

    it "interest payable in the initial year should be the interest rate multiplied by the specified value" do
        year = 1
        expect(@liability.interest_payable(year) ).to eq(value * interest_rate)
    end
    
    it "should return interest payable for a given year based on the balance at that time" do
        year = 3
        expect(@liability.interest_payable(3) ).to eq(@liability.future_value(3) * interest_rate)
    end
end