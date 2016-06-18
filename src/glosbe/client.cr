module Glosbe
  class Client
    API_URL = "https://glosbe.com/gapi_v0_1"

    def initialize
      @cossack = Cossack::Client.new(API_URL)
      yield @cossack
    end

    def initialize
      @cossack = Cossack::Client.new(API_URL)
    end

    # Translate from `from` language into `dest`. Include examples if `tm` is true.
    #
    # ```crystal
    # client.translate("ru", "eo", "привет")
    # ```
    def translate(from : String|Symbol, dest : String|Symbol, phrase : String, tm : Bool = false) : TranslateResponse
      params = { "from" => from, "dest" => dest, "phrase" => phrase, "tm" => tm.to_s }
      http_response = call("translate", params)
      process_http_response(http_response, TranslateResponse)
    end

    # Access translation memory (examples of word usage).
    #
    # ```crystal
    # client.tm("ru", "eo", "привет")
    # ```
    def tm(from : String|Symbol, dest : String|Symbol, phrase : String, page : Integer = 1, page_size : Integer = 30) : TmResponse
      params = { "from" => from, "dest" => dest, "phrase" => phrase, "page" => page.to_s, "pageSize" => page_size.to_s }
      http_response = call("tm", params)
      process_http_response(http_response, TmResponse)
    end

    private def call(method, params)
      params.merge!({"format" => "json"})
      @cossack.get(method, params)
    end

    private def process_http_response(http_response, response_class)
      if http_response.status == 200
        response_class.from_json(http_response.body)
      else
        msg = "#{http_response.status} [#{http_response.status}]"
        raise HttpError.new(msg)
      end
    rescue err : JSON::ParseException
      raise ParseError.new("Can't parse: #{http_response.try &.body}", err)
    end
  end
end
