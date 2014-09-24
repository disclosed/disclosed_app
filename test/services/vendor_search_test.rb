require "test_helper"

describe VendorSearch do
  describe "#search" do
    focus
    it "should return contract data for a vendor" do
      agency1 = Fabricate(:agency, name: "Test agency 1", abbr: "ta1")
      agency2 = Fabricate(:agency, name: "Test Agengy2", abbr: "ta2")
      contract1 = Fabricate(:contract, agency: agency1, vendor_name: "Amex", value: 112345)
      contract2 = Fabricate(:contract, agency: agency2, vendor_name: "Subway", value: 1234)
      contract3 = Fabricate(:contract, agency: agency2, vendor_name: "Amex", value: 123)
      search = VendorSearch.new(vendor: "Amex")
      result = { ta1: [112345], ta2: [123] }
      search.search.must_equal result
    end
  end
end
