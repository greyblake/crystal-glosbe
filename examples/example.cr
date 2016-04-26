require "../src/glosbe"
require "colorize"
require "xml"

client = Glosbe::Client.new

response = client.translate("eo", "en", "danco", true)

puts
puts response.phrase.colorize.bold
puts

puts "Translations: "
response.tuc.each do |translation|
  puts "  #{translation.phrase.try(&.text)}"
  translation.meanings.each do |meaning|
    puts "    #{meaning.text}"
  end
end

puts
puts "Examples: "

good_examples = response.examples.select { |ex| good_example?(ex) }
good_examples.each do |example|
  puts "  #{example.first}"
end

def good_example?(example)
  return false if example.first.nil?

  doc = XML.parse_html(example.first)
  length = doc.text.try(&.size)
  return false if length.nil?

  15 < length < 70
end



def test(word)
  print word
  client = Glosbe::Client.new
  client.translate("de", "eo", word)
  resp = client.tm("de", "eo", word)
  puts " : #{resp.result}"
  pp resp
end

test "einfach"

