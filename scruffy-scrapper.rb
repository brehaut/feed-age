require 'rexml/document'

require './scrappers.rb'

PUBDATE_XPATH = "//*[local-name()='pubDate']|//*[local-name()='updated']|//*[local-name()='published']|//*[local-name()='date']"

class ScruffyScrapper 
    def initialize(text)
        @feed = REXML::Document.new(text)
    end

    def feedLastUpdated() 
        # TODO: pass third argument with full complement of namespaces
        # and remove the garbage local-name shenanigans
        REXML::XPath.match(@feed, PUBDATE_XPATH)
            .map{ |pd| Date.parse pd.text }
            .sort
            .last
    end
end

Scrappers.registerScrapper(ScruffyScrapper) 
