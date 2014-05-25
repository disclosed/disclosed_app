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

    it "should determine the abbr based on the name if no abbr given" do
      AGENCIES.each do |name, details|
        agency = Fabricate(:agency, name: name, abbr: nil)
        agency.abbr.must_equal details["alias"]
      end
    end

    it "should save the given abbr if both name and abbr are provided" do
      ec = Fabricate(:agency, name: "Environment Canada", abbr: "ec")
      ec.abbr.must_equal "ec"
    end

    it "should determine the abbr when the agency name has the wrong case" do
      ec = Fabricate(:agency, name: "environment canada", abbr: nil)
      ec.abbr.must_equal "ec"
    end

    it "should raise an error if the agency is not found" do

      proc {Fabricate(:agency, name: "Fooo!", abbr: nil)}.must_raise Agency::UnknownAgency
    end
  end
end
