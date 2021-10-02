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
        puts table.render(:unicode, alignment: [:center], padding: [0,1] )

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
        total_assets_row = ["TOTAL INCOME"]
        total_liabilities_row = ["TOTAL EXPENSES"]
        net_assets_row = ["NET CASHFLOW"]

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
    
    def print_cashflow
        print_table("cashflow")
    end

    def print_assets_liabilities
        print_table("assets")
    end
end