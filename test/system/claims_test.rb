require "application_system_test_case"

class ClaimsTest < ApplicationSystemTestCase
  setup do
    @claim = claims(:one)
  end

  test "visiting the index" do
    visit claims_url
    assert_selector "h1", text: "Claims"
  end

  test "should create claim" do
    visit claims_url
    click_on "New claim"

    fill_in "Claimed", with: @claim.claimed
    click_on "Create Claim"

    assert_text "Claim was successfully created"
    click_on "Back"
  end

  test "should update Claim" do
    visit claim_url(@claim)
    click_on "Edit this claim", match: :first

    fill_in "Claimed", with: @claim.claimed
    click_on "Update Claim"

    assert_text "Claim was successfully updated"
    click_on "Back"
  end

  test "should destroy Claim" do
    visit claim_url(@claim)
    click_on "Destroy this claim", match: :first

    assert_text "Claim was successfully destroyed"
  end
end
