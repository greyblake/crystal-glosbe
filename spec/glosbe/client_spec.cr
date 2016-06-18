require "../spec_helper"

Spec2.describe Glosbe::Client do
  describe "#initialize" do
    it "allows to access Cossack::Client through block" do
      Glosbe::Client.new do |cossack|
        expect(cossack.class).to eq Cossack::Client
      end
    end

    it "initializes client without block" do
      Glosbe::Client.new
    end
  end

  let(connection) { Cossack::TestConnection.new }

  let(client) do
    Glosbe::Client.new { |cossack| cossack.connection = connection }
  end

  describe "#translate" do
    context "when tm=false" do
      it "returns response with translations" do
        connection.stub_get("/gapi_v0_1/translate?from=eo&dest=en&phrase=amo&tm=false&format=json", {200, fixture("translate_amo")})

        response = client.translate("eo", "en", "amo")

        expect(response).to be_a Glosbe::TranslateResponse
        expect(response.result).to eq "ok"
        expect(response.from).to eq "eo"
        expect(response.dest).to eq "en"
        expect(response.tuc.map(&.phrase.try(&.text))).to eq ["love", "affection", "fondness", "passion", nil]
        expect(response.examples).to eq([] of Glosbe::Example)
      end
    end

    context "when tm=true" do
      it "returns response with translations and exampes" do
        connection.stub_get("/gapi_v0_1/translate?from=eo&dest=en&phrase=amo&tm=true&format=json", {200, fixture("translate_amo_tm")})

        response = client.translate("eo", "en", "amo", true)

        expect(response).to be_a Glosbe::TranslateResponse
        expect(response.result).to eq "ok"
        expect(response.from).to eq "eo"
        expect(response.dest).to eq "en"
        expect(response.tuc.map(&.phrase.try(&.text))).to eq ["love", "affection", "fondness", "passion", nil]
        expect(response.examples.size).to eq 23

        example = response.examples.first
        expect(example.first).to eq "Mia amo"
        expect(example.second).to eq "My love"
      end
    end
  end

  describe "#tm" do
    it "returns examples" do
      connection.stub_get("/gapi_v0_1/tm?from=eo&dest=en&phrase=vivo&page=1&pageSize=30&format=json", {200, fixture("tm_vivo")})

      response = client.tm("eo", "en", "vivo")

      expect(response.class).to eq Glosbe::TmResponse
      expect(response.result).to eq "ok"
      expect(response.found).to eq 872
      expect(response.examples.size).to eq 28

      example = response.examples.first
      expect(example.first).to eq "Mi unuafoje en mia vivo vizitis Romon."
      expect(example.second).to eq "I visited Rome for the first time in my life."
    end
  end
end
