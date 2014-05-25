require "test_helper"

describe Agency do
  describe "Validations" do
    it "must be valid" do
      agency = Fabricate(:agency)
      agency.must_be :valid?
    end

    it "must not be valid if it is missing the required fields" do
      agency = Agency.new
      agency.save.must_equal false
      agency.errors[:name].must_include "can't be blank"
      agency.errors[:abbr].must_include "can't be blank"
    end

    it "must not save if the abbr has already been taken" do
      Fabricate(:agency, :abbr => "moe")
      agency = Fabricate.build(:agency, :abbr => "moe")
      agency.save.must_equal false
      agency.errors[:abbr].must_include "has already been taken"
    end
  end
end
