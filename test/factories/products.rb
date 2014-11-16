module Shoppe
  FactoryGirl.define do
    
    factory :stock_product, :class => Product do
      description         'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      tax_rate            { TaxRate.find_by_rate(20) || create(:standard_tax) }
      stock_control       true
      ignore do
        initial_stock nil
      end

      after(:build) do |product, ev|
        pc = ProductCategory.find_by_permalink('phones') || build(:phones_category)
        product.product_categories << pc
      end
      
      after(:create) do |product, ev|
        if ev.initial_stock
          product.stock_level_adjustments.create(:adjustment => ev.initial_stock, :description => "Initial Stock")
        end
      end
    end
    
    factory :yealink_t22p, :parent => :stock_product do
      name                'Yealink T22P'
      sku                 'YT22P'
      short_description   'An awesome phone which you will absolutely love to use.'
      price               100
      cost_price          50
      weight              1.5
    end
    
    factory :snom_870, :parent => :stock_product do
      name                'Snom 870'
      sku                 'SN870'
      short_description   'An awesome phone which you will absolutely love to use.'
      price               250
      cost_price          125
      weight              2.0
    end

    factory :yealink_headset, :parent => :stock_product do
      name                'Yealink Headset'
      sku                 'YHS32'
      short_description   'An awesome headset which you will absolutely love to use.'
      price               40.00
      cost_price          20.00
      weight              0.5
    end

    factory :software_product, :class => Product do
      name                'Software Product'
      sku                 'SP'
      short_description   'An awesome piece of software which can be purchased.'
      description         'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      price               500.00
      cost_price          10.00
      weight              0.0
      stock_control       false
      tax_rate            { TaxRate.find_by_rate(20) || create(:standard_tax) }

      after(:build) do |product, ev|
        pc = ProductCategory.find_by_permalink('software') || build(:software_category)
        product.product_categories << pc
      end
    end
  
  end
end
