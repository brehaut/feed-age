require 'rubygems'
require 'open-uri'
require 'rexml/document'
require 'date'
require 'pp'

require './plist.rb'

require './scrappers.rb'
require './fancy-scrapper.rb'
require './scruffy-scrapper.rb'


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
    rescue  Exception => e  
        print "error fetching ", feed["name"], "\n"
        print e, "\n\n"
        return nil
    end

    scrapper = Scrappers.getScrapper(xml.read)
    if scrapper == nil
        print "Could not scrape ", feed["name"], "\n"
    end
    scrapper
end 

pp (getCatalog(ARGF.read).map do | (catName, category) | 
    [
        catName, 
        category.map { |dict | [dict["name"], loadFeed(dict)] }
            .select { |(_, scrapper)| scrapper != nil }
            .map { | (feedName, scrapper) | [feedName, scrapper.feedLastUpdated()] }
            .to_h
    ]
end
    .to_h)
    