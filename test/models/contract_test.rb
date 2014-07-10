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
end

