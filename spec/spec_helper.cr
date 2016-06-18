require "../src/glosbe"

require "spec2"

FIXTURES_PATH = File.expand_path("../fixtures", __FILE__)

def fixture(name)
  file_name = File.join(FIXTURES_PATH, "#{name}.json")
  File.read(file_name)
end
