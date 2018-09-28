require 'rexml/document'
include REXML

# a partial implementation of a PList parser; just enough to 
# parse the FeedList.plist from NNW
module PList 
    def PList.array(array) 
        XPath.match(array, "./*").map { | node |  PList.node(node) }.to_a
    end
    
    def PList.dict(dict) 
        XPath.match(dict, "./*")
            .select { | elem | elem.name == "key" }
            .map { | elem | [elem.text, PList.node(elem.next_element)] }
            .to_h    
    end
    
    def PList.node(node) 
        if node.name == "array"
            return PList.array(node)
        elsif node.name == "dict"
            return PList.dict(node)
        elsif node.name == "string"
            return node.text
        end
    end
    
    def PList.parse(doc)
        PList.node(XPath.match(doc, "/plist/*").first)
    end
end    
