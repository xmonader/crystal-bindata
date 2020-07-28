require "option_parser"
require "base64"

enc = Base64.encode("Send reinforcements") # => "U2VuZCByZWluZm9yY2VtZW50cw==\n"
plain = Base64.decode_string(enc)          # => "Send reinforcements"


BUILD_BRANCH = {{ `git rev-parse --abbrev-ref HEAD`.chomp.stringify }}
BUILD_COMMIT = {{ `git rev-parse HEAD`.chomp.stringify }}
# BUILD_LAST_TAG = {{ `git describe --abbrev=0 --tags`.chomp.stringify }}
SHARDS_VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

# VERSION = "crystal-bindata #{BUILD_LAST_TAG} (#{BUILD_BRANCH})##{BUILD_COMMIT})"
VERSION = "crystal-bindata (#{BUILD_BRANCH})##{BUILD_COMMIT})"

thesourcedir = ""
thedestfile = ""
OptionParser.parse! do |parser|
  parser.banner = "Usage: tfwiki [arguments]"
  parser.on("-s SOURCEDIR", "--source=SOURCEDIR", "static data directory") { |sourcedir| thesourcedir = sourcedir }
  parser.on("-d DESTFILE", "--dest=DESTFILE", "static data directory") { |destfile| thedestfile = destfile }

  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.on("-v", "--version", "Version info of tfweb") { puts VERSION }
end



def generate_assets_file_text(d : String)
    assets_file_txt = %q(
require "base64"


module BinData
    @@ASSETS = {} of String => String

    def self.add_asset(thepath : String, b64data : String)
        @@ASSETS[thepath] = b64data
    end
    def self.getAsset(filepath : String)
        Base64.decode_string(@@ASSETS[filepath])
    end

)

  Dir.glob("#{d}/**/*").each do |f|
    fcontent = File.read(f)
    fbase64 = Base64.encode(fcontent)
    assets_file_txt += %Q(
    self.add_asset("#{f}", "#{fbase64}")\n)
  end

  assets_file_txt += "end"
  assets_file_txt
end

if thesourcedir.size != 0 
    thesourcedir = Path[thesourcedir].expand(home:true).to_s

  txt = generate_assets_file_text(thesourcedir)
  if thedestfile.size != 0
    thedestfile =Path[thedestfile].expand(home:true).to_s 
    File.write(thedestfile, txt)
  else 
    puts txt
  end
end
