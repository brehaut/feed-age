require 'rubygems'
require 'open-uri'
require 'rexml/document'
require 'date'
require 'pp'

require './plist.rb'

# TODO: 
# * Handle redirections at all for feeds (http to https specifically though)
# * Handle garbage (or things REXML thinks are garbage) XML (maybe switch to a dirty regexp approach?)
# * Handle JSON feeds at all

HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}; feed age"}

def getCatalog(doc)
    return  PList.parse(REXML::Document.new(doc))
end

def loadFeed(feed)
    begin
        xml = open(feed["url"], HEADERS_HASH)
        feed = REXML::Document.new(xml.read)
        return feed
    rescue  Exception => e  
        print "error scraping ", feed["name"], "\n"
        print e, "\n\n"
        return nil
    end
end 


PUBDATE_XPATH = "//*[local-name()='pubDate']|//*[local-name()='updated']|//*[local-name()='published']|//*[local-name()='date']"

def feedLastUpdated(feedDoc) 
    XPath.match(feedDoc, PUBDATE_XPATH)
         .map{ |pd| Date.parse pd.text }
         .sort
         .last
end

pp (getCatalog(ARGF.read).map do | (catName, category) | 
    [
        catName, 
        category.map { |dict | [dict["name"], loadFeed(dict)] }
            .select { |(_, feed)| feed != nil }
            .map { | (feedName, feed) | [feedName, feedLastUpdated(feed)] }
            .to_h
    ]
end
    .to_h)
    