require "test_helper"

describe ContractLoader do

  describe "unit tests" do
    describe "#extract_dates" do
      before do
        # Skip file parsing in #initialize
        ContractLoader.any_instance.stubs(:parse).returns(nil)
        # Make #extract_dates public for this test
        ContractLoader.send(:public, *ContractLoader.private_instance_methods)
        @loader = ContractLoader.new("fakefile.csv")
      end

      it "should extract dates that look like 2014-01-01" do
        dates = @loader.extract_dates("2004-06-14 to 2005-02-28")
        dates.must_equal [Date.parse("2004-06-14"), Date.parse("2005-02-28")]
        dates = @loader.extract_dates("2013-10-20to 2014-10-18")
        dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
        dates = @loader.extract_dates("2013-10-20to2014-10-18")
        dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
      end

      it "should extract dates that look like Jan 1, 2014" do
        dates = @loader.extract_dates("October 20th, 2013 to October 18th, 2014")
        dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
      end

      it "should extract dates that have a french language divider" do
        dates = @loader.extract_dates("2013-10-20 &agrave; 2014-10-18")

        dates.must_equal [Date.parse("2013-10-20"), Date.parse("2014-10-18")]
      end

      it "should extract dates where only the start date is given" do
        dates = @loader.extract_dates("2013-10-20")
        dates.must_equal [Date.parse("2013-10-20"), nil]
      end

      it "should return nil dates if there is no contract period" do
        dates = @loader.extract_dates(nil)
        dates.must_equal [nil, nil]
        dates = @loader.extract_dates("")
        dates.must_equal [nil, nil]
        dates = @loader.extract_dates("  \n")
        dates.must_equal [nil, nil]
      end

      it "should raise an error if the date string is invalid" do
        proc {@loader.extract_dates("All your base are belong to us")}.must_raise ContractLoaderError
      end
    end
  end

  describe "feature tests" do
    before do
      @loader = ContractLoader.new(Rails.root.join('test/fixtures/sample_contracts.csv'))
    end

    it "should parse the contract data out of the csv file" do

      @loader.contracts.first.must_equal({
        :url => 
  "http://www.oag-bvg.gc.ca/internet/English/con_2013-2014_Q3_e_39047.html",
        :agency => "Office of the Auditor General of Canada",
        :vendor_name => "DNR CONSULTING GROUP",
        :reference_number => "P1400400",
        :contract_date => "2013-10-01",
        :description_of_work => "1282 Computer Equipment - Servers (includes related parts and peripherals)",
        :contract_period => "2013-10-18 to 2013-10-18",
        :something => nil,
        :contract_value => 43900.76,
        :comments => "Purchase of Network equipment. Contract awarded through a Public Works and Government Services Canada (PWGSC) Standing Offer."
      })
    end

    it "should parse the contract period when you only have a start date" do
      @loader.upsert_into_db!
      @loader.contracts.second[:contract_date].must_equal "2013-10-09"
    end

    it "should load contract details correctly" do
      @loader.upsert_into_db!
      contract = Contract.first
      contract.url.must_equal "http://www.oag-bvg.gc.ca/internet/English/con_2013-2014_Q3_e_39047.html"
      contract.vendor_name.must_equal "DNR CONSULTING GROUP"
      contract.reference_number.must_equal "P1400400"
      contract.effective_date.must_equal Date.parse("2013-10-01")
      contract.description.must_equal "1282 Computer Equipment - Servers (includes related parts and peripherals)"
      contract.start_date.must_equal Date.parse("2013-10-18")
      contract.end_date.must_equal Date.parse("2013-10-18")
      contract.value.must_equal 43900
      contract.comments.must_equal "Purchase of Network equipment. Contract awarded through a Public Works and Government Services Canada (PWGSC) Standing Offer."
    end

    it "should update contract details if a contract with same ref number already exists" do
      @loader.upsert_into_db!
      second_loader = ContractLoader.new(Rails.root.join('test/fixtures/sample_contracts_v2.csv'))
      Contract.count.must_equal 5
      second_loader.upsert_into_db!
      Contract.count.must_equal 5
      Contract.where(reference_number: "P1400400").first.vendor_name.must_equal "DNR CONSULTING GROUP INC"
    end

    it "should load all contracts and agencies into the database" do
      Contract.count.must_equal 0
      Agency.count.must_equal 0
      @loader.upsert_into_db!
      Contract.count.must_equal 5
      Agency.count.must_equal 2
    end
  end
end
