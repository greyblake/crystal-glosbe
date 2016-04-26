module Glosbe
  class TranslateResponse
    JSON.mapping({
      result: String,
      phrase: String,
      from: String,
      dest: String,
      tuc: Array(Translation),
      examples: { type: Array(Example), default: [] of Example }
    })
  end

  class Translation
    JSON.mapping({
      phrase: { type: Text, nilable: true },
      meanings: { type: Array(Text), default: [] of Text }
    })
  end

  class Text
    JSON.mapping({
      language: String,
      text: String
    })
  end

  class Example
    JSON.mapping({
      author: { type: UInt32, nilable: true },
      first: String,
      second: String
    })
  end

  class TmResponse
    JSON.mapping({
      result: String,
      found: UInt32,
      examples: { type: Array(Example), default: [] of Example }
    })
  end
end
