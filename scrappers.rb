module Scrappers
    @registeredScrappers = [] 

    def Scrappers.registerScrapper(scrapperClass)
        @registeredScrappers.push(scrapperClass)
    end

    def Scrappers.getScrapper(text)
        @registeredScrappers
            .map do | scrapper |
                    begin
                        return scrapper.new(text)
                    rescue Exception => e 
                    end
                end
            .first
    end
end