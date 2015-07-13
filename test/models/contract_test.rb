require "test_helper"

describe Contract do
  describe "Validations" do
    it "must be valid" do
      Fabricate(:contract, agency: Fabricate(:agency))
    end

    it "must not be valid if the required fields are missing" do
      contract = Contract.new
      contract.save.must_equal false
      contract.errors[:url].must_include "can't be blank"
      contract.errors[:agency].must_include "can't be blank"
    end
  end

  describe "contract start date and end date" do
    it "should parse out the raw contract period on save" do
      contract = Fabricate(:contract, raw_contract_period: "2014-01-10 to 2014-11-12")
      contract.start_date.must_equal Date.parse('2014-01-10')
      contract.end_date.must_equal Date.parse('2014-11-12')
    end

    it "should parse out the raw contract period if the attribute was updated" do
      contract = Fabricate(:contract, raw_contract_period: "2014-01-10 to 2014-11-12")
      contract.update_attributes(raw_contract_period: "2014-01-10 to 2014-11-13")
      contract.end_date.must_equal Date.parse('2014-11-13')
    end

    it "should parse out the raw contract period if the attribute was updated" do
      contract = Fabricate(:contract, raw_contract_period: "2014-01-10 to 2014-11-12")
      ContractPeriodParser.expects(:new).never
      contract.update_attributes(vendor_name: "foo")
    end
  end

  describe "#quarter" do
    it "should return the quarter based on the effective date" do
      contract = Fabricate.build(:contract)
      Scrapers::Quarter.expects(:from_date).with(contract.effective_date)
      contract.quarter
    end
  end
  
  describe "scopes" do
    before do 
      @agency1 = Fabricate(:agency, name: "Test agency 1")
      @agency2 = Fabricate(:agency, name: "Test Agengy2")
      @contract1 = Fabricate(:contract, agency: @agency1, vendor_name: "Amex", value: 112345, effective_date: "2006-01-01", description: "money")
      @contract2 = Fabricate(:contract, agency: @agency2, vendor_name: "Subway", value: 1234, effective_date: "2007-02-02", description: "cooking") 
      @contract3 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 123, effective_date: "2008-03-03", description: "money")
    end 

    it "should return contracts given the vendor name" do
      Contract.vendor_name("Amex").must_equal [@contract1, @contract3]
    end
    
    it "should return contracts given the effective date" do
      Contract.effective_date("2007-02-02").must_equal [@contract2]
    end

    it "should return contracts given the description" do
      Contract.description("cooking").must_equal [@contract2]
    end

    it "should return contracts given the value of the contract" do
      skip
      Contract.value("123").must_equal [@contract3]
    end

  end

  describe "::contract_for" do
    before do
      @agency = Fabricate(:agency)
    end

    it "should return the contract if there is only one" do
      contract = Fabricate(:contract, reference_number: "A100", effective_date: 1.year.ago, agency: @agency)
      contract_attrs = Fabricate.attributes_for(:contract, reference_number: "A100", effective_date: 1.year.ago, agency: @agency)
      Contract.contract_for(contract_attrs).must_equal contract
    end

    it "should return nil if the contract doesn't exist" do
      contract_attrs = Fabricate.attributes_for(:contract, reference_number: "A100", effective_date: 1.year.ago, agency: @agency)
      Contract.contract_for(contract_attrs).must_equal nil
    end

    it "should return the contract if there is more than one contract with the same ref number" do
      contract = Fabricate(:contract, reference_number: "A100", effective_date: 1.year.ago, agency: @agency)
      contract2 = Fabricate(:contract, reference_number: "A100", effective_date: 6.months.ago, agency: @agency)
      contract_attrs = Fabricate.attributes_for(:contract, reference_number: "A100", effective_date: 6.months.ago, agency: @agency)
      Contract.contract_for(contract_attrs).must_equal contract2
    end

    it "should return nil if there is more than one contract with the same ref number but the date is different" do
      contract = Fabricate(:contract, reference_number: "A100", effective_date: 1.year.ago, agency: @agency)
      contract2 = Fabricate(:contract, reference_number: "A100", effective_date: 6.months.ago, agency: @agency)
      contract_attrs = Fabricate.attributes_for(:contract, reference_number: "A100", effective_date: 3.months.ago, agency: @agency)
      Contract.contract_for(contract_attrs).must_equal nil
    end
  end

  describe "::spending_per_vendor" do 
    before do
      @agency1 = Fabricate(:agency, name: "Test agency 1")
      @agency2 = Fabricate(:agency, name: "Test Agengy2")
      @contract1 = Fabricate(:contract, agency: @agency1, vendor_name: "Amex", value: 112345, effective_date: "2006-01-01")
      @contract2 = Fabricate(:contract, agency: @agency2, vendor_name: "Subway", value: 1234, effective_date: "2007-02-02") 
      @contract3 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 123, effective_date: "2008-03-03")
      @contract4 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 1234, effective_date: "2008-04-04")
      @contract5 = Fabricate(:contract, agency: @agency2, vendor_name: "Amex", value: 12345, effective_date: "2009-05-05")
    end

    it "should display total contract sum of the given vendor for the year" do
      skip
      query = Contract.spending_per_vendor("Amex")
      result = [12345, 1357, 12345]
      query.must_be_same_as result
    end
  end
end
