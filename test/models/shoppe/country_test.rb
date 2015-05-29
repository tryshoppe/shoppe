require 'test_helper'

module Shoppe
  class CountryTest < ActiveSupport::TestCase
    should have_many(:billed_orders).dependent(:restrict_with_exception).class_name('Shoppe::Order')
    should have_many(:delivered_orders).dependent(:restrict_with_exception).class_name('Shoppe::Order')

    should validate_presence_of(:name)

    setup do
      @uk = create(:uk)
      @us = create(:us)
      @france = create(:france)
    end

    test "scope should be ordered" do
      assert_equal Shoppe::Country.ordered, [@france, @uk, @us]
    end
  end
end