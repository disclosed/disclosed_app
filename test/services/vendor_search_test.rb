require "test_helper"
describe VendorSearch do
  before do
    @agency1 = Fabricate(:agency, name: "Test agency 1")
    @agency2 = Fabricate(:agency, name: "Test Agengy2")
    @contract1 = Fabricate(:contract, agency: @agency1, vendor_name: "Amex", value: 112345, effective_date: "2006-01-01")
    @contract2 = Fabricate(:contract, agency: @agency2, vendor_name: "Subway", value: 1234, effective_date: "2007-02-02") 
    @contract3 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 123, effective_date: "2008-03-03")
    @contract4 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 1234, effective_date: "2008-04-04")
    @contract5 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 12345, effective_date: "2009-05-05")
  end
  
  describe "#search" do
    it "should return contract data for a vendor" do
      search = VendorSearch.new(vendor: "Amex")
      result = [["Amex", 112345, 1357, 12345]] 
      search.search.must_equal result
    end
  end
end
