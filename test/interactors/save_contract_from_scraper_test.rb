require "test_helper"
describe SaveContractFromScraper do
  before do
    @agency = Fabricate.create(:agency)
  end
  describe "contract is new" do

    before do
      Contract.any_instance.stubs(:contract_for).returns(nil)
    end
    it "should save the contract" do
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123")
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.success?.must_equal true
      Contract.where(reference_number: "A123").count.must_equal 1
    end

    it "should fail if the contract is missing the reference_number" do
      attrs = Fabricate.attributes_for(:contract, reference_number: nil)
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.success?.must_equal false
      context.message.must_equal "  Can't save contract. Missing mandatory attributes. [\"Reference number can't be blank\"]. URL: http://www.oag-bvg.gc.ca/internet/English/contract/1234.html"
    end

    it "should fail if the contract is missing the effective_date" do
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123", effective_date: nil)
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.success?.must_equal false
      Contract.find_by(reference_number: "A123").must_equal nil
      context.message.must_equal "  Can't save contract. Missing mandatory attributes. [\"Effective date can't be blank\"]. URL: http://www.oag-bvg.gc.ca/internet/English/contract/1234.html"
    end

    it "should save if the contract is missing a field that is not mandatory" do
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123", value: nil)
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.success?.must_equal true
      Contract.find_by(reference_number: "A123").wont_equal nil
      context.contract.needs_scrubbing.must_equal true
    end

    it "should not override the needs scrubbing field if it is set to true" do
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123")
      attrs[:needs_scrubbing] = true
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.contract.needs_scrubbing.must_equal true
    end
  end

  describe "contract already in database" do
    before do
      Fabricate(:contract, reference_number: "A123")
      Contract.any_instance.stubs(:contract_for).returns(@contract)
    end
    it "should update contract" do
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123")
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.success?.must_equal true
      Contract.find_by(reference_number: "A123").wont_equal nil
    end
    it "should update a value in the db with a new value from the scraper" do
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123", value: 1234)
      context = SaveContractFromScraper.call(attributes: attrs, agency: @agency)
      context.success?.must_equal true
      Contract.find_by(reference_number: "A123").value.must_equal 1234
    end
  end
end

