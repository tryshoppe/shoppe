module Shoppe
  
  # The Shoppe::Country model stores countries which can be used for delivery & billing
  # addresses for orders.
  #
  # You can use the Shoppe::CountryImporter to import a pre-defined list of countries 
  # into your database. This automatically happens when you run the 'shoppe:setup' 
  # rake task.
  
  class Country < ActiveRecord::Base
    
    self.table_name = 'shoppe_countries'
    
    # All orders which have this country set as their billing country
    has_many :billed_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'billing_country_id'
    # All orders which have this country set as their delivery country
    has_many :delivered_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'delivery_country_id'

    validates :name, :presence => true

    # All countries ordered by their name ascending
    scope :ordered, -> { order(:name => :asc) }
  end
end
