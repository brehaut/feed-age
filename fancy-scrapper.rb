begin
    require 'nokogiri'
    require 'feedjira'

    require './scrappers.rb'

    class FancyScrapper 
        def new(text)
            @feed = Feedjira.parse(text)
        end

        def feedLastUpdated()
            if @feed.respond_to? :published
                return @feed.published
            elsif @feed.respond_to? :last_modified
                return @feed.last_modified
            end
            if @feed.entries.length == 0 
                return nil
            end
            first = @feed.entries.first
            if first.respond_to? :published
                return first.published
            end 
        end
    end

    Scrappers.registerScrapper(FancyScrapper) 

rescue LoadError => le
    puts "Couldnt import the fancy scraper. falling back to the primative one"
    puts le
end



