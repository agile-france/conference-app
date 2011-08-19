require 'spec_helper'

describe Conference do
  it {should reference_many(:products)}

  it 'has a conpound id : #{name}-#{edition}' do
    assert {Conference.new(:name => 'xp', :edition => '2030').id == "xp-2030"}
  end

  describe "#owner" do
    let(:xp) {Fabricate.build(:conference)}
    let(:xp_dot_org) {Fabricate.build(:user, :email => 'conf@xp.org')}
    it "is a user, representing organization of conference" do
      assert {xp.owner == nil}
      xp.owner = xp_dot_org
      assert {xp.owner == xp_dot_org}
    end
  end

  describe "#new_invoice_for" do
    let!(:xp) {Ducks.conference}
    let!(:place) {xp.products.first}
    let!(:john) {Fabricate.build(:user)}
    let!(:registration) {Fabricate.build(:registration, :user => john, :product => place)}
    it "builds an invoice for all executions of user, not yet invoiced" do
      invoice = xp.new_invoice_for(john)
      deny {invoice.persisted?}
      assert {invoice.registrations.empty?}
      assert {invoice.user == john}
    end
  end
end