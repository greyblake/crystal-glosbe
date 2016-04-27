require "../spec_helper"

describe Glosbe::Client do
  describe "#translate" do
    context "when tm=false" do
      it "returns response with translations" do
        WebMock.stub(:get, "glosbe.com/gapi_v0_1/translate?from=eo&dest=en&phrase=amo&tm=false&format=json")
          .to_return(fixture("translate_amo"))

        client = Glosbe::Client.new
        response = client.translate("eo", "en", "amo")

        response.class.should eq Glosbe::TranslateResponse
        response.result.should eq "ok"
        response.from.should eq "eo"
        response.dest.should eq "en"
        response.tuc.map(&.phrase.try(&.text)).should eq ["love", "affection", "fondness", "passion", nil]
        response.examples.should eq([] of Glosbe::Example)
      end
    end

    context "when tm=true" do
      it "returns response with translations and exampes" do
        WebMock.stub(:get, "glosbe.com/gapi_v0_1/translate?from=eo&dest=en&phrase=amo&tm=true&format=json")
          .to_return(fixture("translate_amo_tm"))

        client = Glosbe::Client.new
        response = client.translate("eo", "en", "amo", true)

        response.class.should eq Glosbe::TranslateResponse
        response.result.should eq "ok"
        response.from.should eq "eo"
        response.dest.should eq "en"
        response.tuc.map(&.phrase.try(&.text)).should eq ["love", "affection", "fondness", "passion", nil]
        response.examples.size.should eq 23

        example = response.examples.first
        example.first.should eq "Mia amo"
        example.second.should eq "My love"
      end
    end
  end

  describe "#tm" do
    it "returns examples" do
      WebMock.stub(:get, "glosbe.com/gapi_v0_1/tm?from=eo&dest=en&phrase=vivo&page=1&pageSize=30&format=json")
        .to_return(fixture("tm_vivo"))

      client = Glosbe::Client.new
      response = client.tm("eo", "en", "vivo")

      response.class.should eq Glosbe::TmResponse
      response.result.should eq "ok"
      response.found.should eq 872
      response.examples.size.should eq 28

      example = response.examples.first
      example.first.should eq "Mi unuafoje en mia vivo vizitis Romon."
      example.second.should eq "I visited Rome for the first time in my life."
    end
  end
end
