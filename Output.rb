require("tty-table")

class Output

    def initialize(objects)
        @objects = objects
    end


    def print_table(type)
        header = ["Item"]
        for i in 1..Assumptions.years do
            header << "Year #{i}"
        end
        
        rows = (type == "cashflow" ?  get_cashflow_rows : get_asset_liability_rows)

        table = TTY::Table.new(header, rows)
        puts table.render(:unicode, alignment: [:center], padding: [0,1] )

        sleep(5)
        # TO DO: DISPLAY (AND NAVIGATE/SCROLL?) UNTIL EXIT SPECIFIED - MB JUST EXIT FOR NOW IS FINE
    end

    def get_asset_liability_rows
        rows = []
        
        for asset in @objects.assets
            row = [asset.name]
            for year in 1..Assumptions.years
                row << asset.future_value(year).round
            end
            rows << row
        end

        # ASSETS
            # asset objects
        # LIABILITIES
            # liability objects
        # SUMMARY
            # total assets
            # total loans
            # PV?
        return rows
    end

    
    def get_cashflow_rows
        rows = []
        
        # for asset in @objects.assets
        #     row = [asset.name]
        #     for year in 1..Assumptions.years
        #         row << asset.future_value(year).round
        #     end
        #     p row.length
        #     rows << row
        # end

        # INCOMES
            # income objects
            # asset incomes
            # new loans
        # EXPENSES
            # expense objects
            # tax
            # loan interest
            # principal repayments
            # new assets
        # SUMMARY
            # total income
            # total expenses
            # surplus/deficit
        return rows
    end
    
    def print_cashflow
        print_table("cashflow")
    end

    def print_assets_liabilities
        print_table("assets")
    end
end