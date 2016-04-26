module Glosbe
  class Client
    API_URL = "https://glosbe.com/gapi_v0_1/"

    def translate(from : String|Symbol, dest : String|Symbol, phrase : String, tm : Bool = false) : TranslateResponse
      params = { "from" => from, "dest" => dest, "phrase" => phrase, "tm" => tm.to_s }
      http_response = call("translate", params)
      process_http_response(http_response, TranslateResponse)
    end

    def tm(from : String|Symbol, dest : String|Symbol, phrase : String, page : Integer = 1, page_size : Integer = 30) : TmResponse
      params = { "from" => from, "dest" => dest, "phrase" => phrase, "page" => page.to_s, "pageSize" => page_size.to_s }
      http_response = call("tm", params)
      process_http_response(http_response, TmResponse)
    end

    private def call(method, params)
      params.merge!({"format" => "json"})
      params_str = HTTP::Params.build do |form|
        params.each { |name, val| form.add(name, val) }
      end
      url = "#{API_URL}/#{method}?#{params_str}"
      http_response = HTTP::Client.get(url)
    end

    private def process_http_response(http_response, response_class)
      if http_response.success?
        response_class.from_json(http_response.body)
      else
        msg = "#{http_response.status_message} [#{http_response.status_code}]"
        raise HttpError.new(msg)
      end
    rescue err : JSON::ParseException
      raise ParseError.new("Cannot parse: #{http_response.try &.body}", err)
    end
  end
end
