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
        STDERR.puts "error fetching ", feed["name"]
        STDERR.puts "\t", e, "\n"
        return nil
    end

    scrapper = Scrappers.getScrapper(xml.read)
    if scrapper == nil
        STDERR.puts "Could not scrape ", feed["name"]
    end
    scrapper
end 

(PList.serialize (getCatalog(ARGF.read).map do | (catName, category) | 
        [
            catName, 
            category.map { |dict | [dict["name"], loadFeed(dict)] }
                .select { |(_, scrapper)| scrapper != nil }
                .map { | (feedName, scrapper) | [feedName, scrapper.feedLastUpdated().to_s] }
                .to_h
        ]
    end
    .to_h))
    .write $stdout

    