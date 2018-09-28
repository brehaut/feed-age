This is a really rough ruby script to fetch the some metadata for everything in the NetNewsWire feed directory.
Sorry about the messy and awful ruby, it’s not a language I’m familiar with.

The `main.rb` script takes the `FeedList.plist` file in either standard input or as a file argument and produces a new plist on standard output, for example:

    $ curl https://raw.githubusercontent.com/brentsimmons/NetNewsWire/master/NetNewsWire/FeedList/FeedList.plist | ruby main.rb > output.plist

or:

    $ ruby main.rb FeedList.plist > output.plist

## Dependancies:

If you have managed to install `feedjira` and its `nokogiri` dependency (requires up to date XCode and command line tools to build the native extensions) then it will use that for a smarter feed scrapper. If you don’t (or for whatever reason that parser can’t scrape the feed), it falls back to a bodgy REXML and xpath based scrapper. Theoretically everything is set up right so that a `bundle install` will install things correctly if the required tools are present?

## Things it doesn’t do yet:

 * Handle HTTP redirects or other problems at all gracefully. This is just using the basic ruby `open` with `open-uri`. 
 * Handle feeds that either the XML parsers think is invalid.  
 * JSON feed at all.
