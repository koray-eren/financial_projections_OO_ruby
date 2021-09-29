class Assumptions
    @@indexation = 0.025
    @@years = 10
    @@tax_rate = 0.3

    def self.indexation
        @@indexation
    end

    def self.years
        @@years
    end

    def self.tax_rate
        @@tax_rate
    end
end