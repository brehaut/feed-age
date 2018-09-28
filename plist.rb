require 'rexml/document'
include REXML

# a partial implementation of a PList parser; just enough to 
# parse the FeedList.plist from NNW
module PList 
    def PList.parse(doc)
        PList.nodeFromXML(XPath.match(doc, "/plist/*").first)
    end

    def PList.serialize(struct)
        doc = Document.new '<?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0"></plist>'
        doc.root.elements << PList.xmlFromStruct(struct)

        doc
    end

    

    def PList.arrayFromXML(array) 
        XPath.match(array, "./*").map { | node |  PList.nodeFromXML(node) }.to_a
    end
    
    def PList.dictFromXML(dict) 
        XPath.match(dict, "./*")
            .select { | elem | elem.name == "key" }
            .map { | elem | [elem.text, PList.nodeFromXML(elem.next_element)] }
            .to_h    
    end
    
    def PList.nodeFromXML(node) 
        if node.name == "array"
            return PList.arrayFromXML(node)
        elsif node.name == "dict"
            return PList.dictFromXML(node)
        elsif node.name == "string"
            return node.text
        end
    end



    def PList.xmlFromStruct(struct)
        if struct.is_a? Hash
            PList.xmlFromHash(struct)
        elsif struct.is_a? Array
            PList.xmlFromArray(struct)
        elsif struct.is_a? String
            el = Element.new "string"
            el.text = struct
            return el
        end
    end

    def PList.xmlFromHash(hash)
        dict = Element.new "dict"
        hash.each do | (name, substruct) | 
            key = Element.new "key"
            key.text = name
            dict.elements << key
            dict.elements << PList.xmlFromStruct(substruct)
        end
        dict
    end

    def PList.xmlFromArray(arr)
        arrayEl = Element.new "array"
        arr.each do | substruct | 
            arrayEl.elements << PList.xmlFromStruct(substruct)
        end
    end
end    
