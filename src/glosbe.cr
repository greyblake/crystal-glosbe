require "json"
require "http"
require "cossack"

require "./glosbe/*"

module Glosbe
  class Error < ::Exception; end
  class HttpError < Error; end
  class ParseError < Error; end
end
