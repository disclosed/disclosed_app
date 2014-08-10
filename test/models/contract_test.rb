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
      contract.errors[:vendor_name].must_include "can't be blank"
      # contract.errors[:start_date].must_include "can't be blank"
      # contract.errors[:effective_date].must_include "can't be blank"
      contract.errors[:value].must_include "can't be blank"
      contract.errors[:agency].must_include "can't be blank"
    end
  end

  describe "::extract_dates" do
    it "should extract dates that look like 2014-01-01" do
      dates = Contract.extract_dates("2004-06-14 to 2005-02-28")
      dates.must_equal [Date.parse("2004-06-14"), Date.parse("2005-02-28")]
      dates = Contract.extract_dates("2013-10-20to 2014-10-18")
      dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
      dates = Contract.extract_dates("2013-10-20to2014-10-18")
      dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
    end

    it "should extract dates that look like Jan 1, 2014" do
      dates = Contract.extract_dates("October 20th, 2013 to October 18th, 2014")
      dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
    end

    it "should extract dates that have a french language divider" do
      dates = Contract.extract_dates("2013-10-20 &agrave; 2014-10-18")

      dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
    end

    it "should extract dates where only the start date is given" do
      dates = Contract.extract_dates("2013-10-20")
      dates.must_equal [Date.parse("2013-10-20"), nil]
    end

    it "should return nil dates if there is no contract period" do
      dates = Contract.extract_dates(nil)
      dates.must_equal [nil, nil]
      dates = Contract.extract_dates("")
      dates.must_equal [nil, nil]
      dates = Contract.extract_dates("  \n")
      dates.must_equal [nil, nil]
    end

    it "should raise an error if the date string is invalid" do
      proc {Contract.extract_dates("All your base are belong to us")}.must_raise ArgumentError
    end
  end

  describe "::create_or_update" do
    before do
      @agency = Fabricate(:agency)
    end

    it "should create a record if a reference number doesn't exist" do
      contract_attrs = Fabricate.attributes_for(:contract, reference_number: "A100", agency: @agency)
      Contract.create_or_update!(contract_attrs)
      Contract.find_by(reference_number: "A100").wont_equal nil
    end

    it "should update a record if the reference number exists" do
      contract = Fabricate(:contract, reference_number: "A123", agency: @agency)
      attrs = Fabricate.attributes_for(:contract, reference_number: "A123", vendor_name: "New Company Inc.")
      contract = Contract.create_or_update!(attrs)
      contract.must_be :persisted?
      Contract.find_by(reference_number: "A123").vendor_name.must_equal "New Company Inc."
    end

    it "should raise an exception if the contract data is invalid" do
      contract_attrs = Fabricate.attributes_for(:contract, reference_number: "A100", vendor_name: nil, agency: @agency)

      proc { Contract.create_or_update!(contract_attrs) }.must_raise ActiveRecord::RecordInvalid
    end
  end
end

