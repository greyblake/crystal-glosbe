require "../src/glosbe"

client = Glosbe::Client.new

# Translate a word from German to English
response = client.translate("de", "en", "Achtung", tm: true)  # =>  #<Glosbe::TranslateResponse ... >

# Print translations
response.tuc.each do |translation|
  puts translation.phrase.try(&.text)
end

# Print examples of usage
response.examples.each do |example|
  puts example.first    # sentence in German
  puts example.second   # translation in English
end
