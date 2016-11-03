module Shoppe
  # The Shoppe::Country model stores countries which can be used for delivery & billing
  # addresses for orders.
  #
  # You can use the Shoppe::CountryImporter to import a pre-defined list of countries
  # into your database. This automatically happens when you run the 'shoppe:setup'
  # rake task.

  class Country < ApplicationRecord
    self.table_name = 'shoppe_countries'

    # All orders which have this country set as their billing country
    has_many :billed_orders, dependent: :restrict_with_exception, class_name: 'Shoppe::Order', foreign_key: 'billing_country_id'

    # All orders which have this country set as their delivery country
    has_many :delivered_orders, dependent: :restrict_with_exception, class_name: 'Shoppe::Order', foreign_key: 'delivery_country_id'

    # All countries ordered by their name asending
    scope :ordered, -> { order(name: :asc) }

    # Validations
    validates :name, presence: true
  end
end
