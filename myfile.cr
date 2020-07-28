
require "base64"


module BinData
    @@ASSETS = {} of String => String

    def self.add_asset(thepath : String, b64data : String)
        @@ASSETS[thepath] = b64data
    end
    def self.getAsset(filepath : String)
        Base64.decode_string(@@ASSETS[filepath])
    end


    self.add_asset("/home/xmonader/wspace/crystal-bindata/spec/spec_helper.cr", "cmVxdWlyZSAic3BlYyIKcmVxdWlyZSAiLi4vc3JjL2NyeXN0YWwtYmluZGF0
YSIK
")

    self.add_asset("/home/xmonader/wspace/crystal-bindata/spec/crystal-bindata_spec.cr", "cmVxdWlyZSAiLi9zcGVjX2hlbHBlciIKCmRlc2NyaWJlIENyeXN0YWw6OkJp
bmRhdGEgZG8KICAjIFRPRE86IFdyaXRlIHRlc3RzCgogIGl0ICJ3b3JrcyIg
ZG8KICAgIGZhbHNlLnNob3VsZCBlcSh0cnVlKQogIGVuZAplbmQK
")
end
