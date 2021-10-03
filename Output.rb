require("tty-table")
require("tty-prompt")

class Output

    def initialize(objects)
        @objects = objects
        @prompt = TTY::Prompt.new
    end

    def print_table(type)
        system("clear")
        puts "#{type == "cashflow" ?  "Cashflow" : "Assets & Liabilities"} Table"
        header = ["Item"]
        for i in 1..Assumptions.years do
            header << "Year #{i}"
        end
        
        rows = (type == "cashflow" ?  get_cashflow_rows : get_asset_liability_rows)

        table = TTY::Table.new(header, rows)
        puts table.render(:unicode, alignment: [:center], padding: [0,1], resize: true )

        @prompt.keypress("Press space or enter to go back", keys: [:space, :return])
    end

    def get_asset_liability_rows
        rows = [:separator]
        total_assets_row = ["TOTAL ASSETS"]
        total_liabilities_row = ["TOTAL LIABILITIES"]
        net_assets_row = ["NET ASSETS"]

        row = ["ASSETS"]
        for year in 1..Assumptions.years
            row << ""
            total_assets_row << 0
            total_liabilities_row << 0
            net_assets_row << 0
        end
        rows << row << :separator
        
        for asset in @objects.assets
            row = [asset.name]
            for year in 1..Assumptions.years
                year_value = asset.future_value(year).round
                row << year_value
                total_assets_row[year] += year_value
                net_assets_row[year] += year_value
            end
            rows << row
        end
        
        rows << :separator

        row = ["LIABILITIES"]
        for year in 1..Assumptions.years
            row << ""
        end
        rows << row << :separator

        for liability in @objects.liabilities
            row = [liability.name]
            for year in 1..Assumptions.years
                year_value = liability.future_value(year).round
                row << year_value
                total_liabilities_row[year] += year_value
                net_assets_row[year] -= year_value
            end
            rows << row
        end

        rows << :separator << total_assets_row << total_liabilities_row << net_assets_row
        
        return rows
    end
    
    def get_cashflow_rows
        rows = [:separator]
        total_income_row = ["TOTAL INCOME"]
        total_expenses_row = ["TOTAL EXPENSES"]
        net_cashflow_row = ["NET CASHFLOW"]
        taxable_income = []

        # INCOME SECTION

        # header
        row = ["INCOME"]
        for year in 1..Assumptions.years
            row << ""
            total_income_row << 0
            total_expenses_row << 0
            net_cashflow_row << 0
            taxable_income << 0
        end
        rows << row << :separator
        
        # income from income objects
        for income in @objects.income
            row = [income.name]
            for year in 1..Assumptions.years
                year_value = income.future_value(year).round
                row << year_value
                total_income_row[year] += year_value
                net_cashflow_row[year] += year_value
                income.taxable ? taxable_income[year-1] += year_value : nil
            end
            rows << row
        end

        # income from assets
        for asset in @objects.assets
            row = ["#{asset.name} income"]
            for year in 1..Assumptions.years
                year_value = asset.year_n_income(year).round
                row << year_value
                total_income_row[year] += year_value
                net_cashflow_row[year] += year_value
                taxable_income[year-1] += year_value
            end
            rows << row
        end

        # income from asset sales
        for asset in @objects.assets
            if asset.sale_year != nil
                row = ["#{asset.name} sale"]
                for year in 1..Assumptions.years
                    year_value = (year == asset.sale_year ? (asset.future_value(year - 1) * (1 + asset.growth_rate) ).round : 0)
                    row << year_value
                    total_income_row[year] += year_value
                    net_cashflow_row[year] += year_value
                    taxable_income[year-1] += year_value
                end
                rows << row
            end
        end

        # income from new liabilities
        for liability in @objects.liabilities
            row = ["#{liability.name}"]
            if liability.first_year != 0
                for year in 1..Assumptions.years
                    year_value = (year == liability.first_year ? liability.future_value(year).round : 0)
                    row << year_value
                    total_income_row[year] += year_value
                    net_cashflow_row[year] += year_value
                end
                rows << row
            end
        end

        # EXPENSES SECTION

        # header
        rows << :separator
        row = ["EXPENSES"]
        for year in 1..Assumptions.years
            row << ""
        end
        rows << row << :separator

        # expenses from expense objects
        for expense in @objects.expenses
            row = [expense.name]
            for year in 1..Assumptions.years
                year_value = expense.future_value(year).round
                row << year_value
                total_expenses_row[year] += year_value
                net_cashflow_row[year] -= year_value
                expense.deductible ? taxable_income[year-1] -= year_value : nil
            end
            rows << row
        end

        # purchase of new assets
        for asset in @objects.assets
            row = ["#{asset.name} purchase"]
            if asset.first_year != 0
                for year in 1..Assumptions.years
                    year_value = (year == asset.first_year ? asset.future_value(year).round : 0)
                    row << year_value
                    total_expenses_row[year] += year_value
                    net_cashflow_row[year] -= year_value
                end
                rows << row
            end
        end
        
        # loan interest
        for liability in @objects.liabilities
            row = ["#{liability.name} interest"]
            for year in 1..Assumptions.years
                year_value = liability.interest_payable(year).round
                row << year_value
                total_expenses_row[year] += year_value
                net_cashflow_row[year] -= year_value
                liability.deductible ? taxable_income[year-1] -= year_value : nil
            end
            rows << row
        end

        # principal repayments
        for liability in @objects.liabilities
            if liability.principal_repayments != 0
                row = ["#{liability.name} repayment"]
                for year in 1..Assumptions.years
                    year_value = liability.principal_repayment(year).round
                    row << year_value
                    total_expenses_row[year] += year_value
                    net_cashflow_row[year] -= year_value
                end
                rows << row
            end
        end

        # tax
        income_tax_row = taxable_income.map {|income| (income * Assumptions.tax_rate).round }
        income_tax_row.unshift("Income Tax")
        rows << income_tax_row

        for year in 1..Assumptions.years do
            total_expenses_row[year] += income_tax_row[year]
            net_cashflow_row[year] -= income_tax_row[year]
        end

        # SUMMARY SECTION
        rows << :separator << total_income_row << total_expenses_row << net_cashflow_row
        
        return rows

    end
    
    def print_cashflow
        print_table("cashflow")
    end

    def print_assets_liabilities
        print_table("assets")
    end
end