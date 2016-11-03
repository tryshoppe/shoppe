require 'ostruct'

module Shoppe
  class Setting < ApplicationRecord
    # Validations
    validates :key, presence: true, uniqueness: true
    validates :value, presence: true
    validates :value_type, presence: true

    before_validation do
      self.value_type = I18n.t('shoppe.settings.types')[key.to_sym].try(:capitalize) || value.class.to_s
      self.value      = encoded_value
    end

    # The encoded value for saving in the backend (as a string)
    #
    # @return [String]
    def encoded_value
      case value_type
      when 'Array', 'Hash'  then  value.to_json
      when 'Boolean'        then  value.to_s == 'true' ? 'true' : 'false'
      else                        value.to_s
      end
    end

    # The decoded value for the setting attribute (in it's native type)
    #
    # @return [Object]
    def decoded_value
      case value_type
      when 'Fixnum'         then  value.to_i
      when 'Float'          then  value.to_f
      when 'Array', 'Hash'  then  JSON.parse(value)
      when 'Boolean'        then  value == 'true' ? true : false
      else                        value.to_s
      end
    end

    # A full hash of all settings available in the current scope
    #
    # @return [Hash]
    def self.to_hash
      all.inject({}) do |h, setting|
        h[setting.key.to_s] = setting.decoded_value
        h
      end
    end

    # Update settings from a given hash and persist them. Accepts a
    # hash of keys (which should be strings).
    #
    # @return [Hash]
    def self.update_from_hash(hash)
      existing_settings = all.to_a
      hash.each do |key, value|
        existing = existing_settings.find { |s| s.key.to_s == key.to_s }
        if existing
          value.blank? ? existing.destroy! : existing.update!(value: value)
        else
          value.blank? ? nil : create!(key: key, value: value)
        end
      end
      hash
    end
  end
end
