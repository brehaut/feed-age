# a partial implementation of a PList parser; just enough to 
# parse the FeedList.plist from NNW
module PList 
    def PList.array(array) 
        array.xpath("./*").map { | node |  PList.node(node) }.to_a
    end
    
    def PList.dict(dict) 
        dict.xpath("./*")
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
        PList.node(doc.xpath("/plist/*")[0])
    end
end    
