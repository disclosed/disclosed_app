require "test_helper"

describe Api::ContractsController do
  it "should get index" do
    get :index
    assert_response :success
  end

  it "should get show" do
    get :show
    assert_response :success
  end

  it "should get create" do
    get :create
    assert_response :success
  end

  it "should get filter" do
    get :filter
    assert_response :success
  end

end
