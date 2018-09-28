require 'rubygems'
require 'open-uri'
require 'rexml/document'
require 'date'
require 'pp'

require './plist.rb'

# TODO: replace this with reading from stdin or a file
PLIST_URL = "https://raw.githubusercontent.com/brentsimmons/NetNewsWire/master/NetNewsWire/FeedList/FeedList.plist"
# PLIST_URL = "dummy.plist"


HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}; feed age"}


def getCatalog(uri)
    return  PList.parse(REXML::Document.new(open(uri)))
end



def loadFeed(feed)
    begin
        xml = open(feed["url"], HEADERS_HASH)
        feed = REXML::Document.new(xml.read)
        return feed
    rescue
        print "error scraping ", feed["name"]
        return nil
    end
end 

PUBDATE_XPATH = "//pubDate|//updated|//published"

def feedLastUpdated(feedDoc) 
    XPath.match(feedDoc, PUBDATE_XPATH)
         .map{ |pd| Date.parse pd.text }
         .sort
         .last
end

pp (getCatalog(PLIST_URL).map do | (catName, category) | 
    [
        catName, 
        category.map { |dict | [dict["name"], loadFeed(dict)] }
            .select { |(_, feed)| feed != nil }
            .map { | (feedName, feed) | [feedName, feedLastUpdated(feed)] }
            .to_h
    ]
end
    .to_h)
    