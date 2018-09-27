require 'rubygems'
require 'feedjira'
require 'open-uri'
require 'nokogiri'

require './plist.rb'

# TODO: replace this with reading from stdin or a file
# PLIST_URL = "https://raw.githubusercontent.com/brentsimmons/NetNewsWire/master/NetNewsWire/FeedList/FeedList.plist"
PLIST_URL = "dummy.plist"


HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}; feed age"}


def getCatalog(uri)
    return  PList.parse(Nokogiri::XML(open(uri)))
end



def loadFeed(feed)
    begin
        xml = open(feed["url"], HEADERS_HASH)
        feed = Feedjira::Feed.parse(xml.read)
        return feed
    rescue
        print "error scraping ", feed["name"]
        return nil
    end
end 

def feedLastUpdated(feed) 
    if feed.respond_to? :published
        return feed.published
    elsif feed.respond_to? :last_modified
        return feed.last_modified
    end

    if feed.entries.length == 0 
        return nil
    end

    first = feed.entries.first

    if first.respond_to? :published
        return first.published
    end 
end


getCatalog(PLIST_URL).each do | (name, category) | 
    print "category: ", name, "\n"
    print category.map { |dict | loadFeed(dict) }
            .select { |feed| feed != nil }
            .map { |feed | feedLastUpdated(feed) } 
    print "\n\n"
end