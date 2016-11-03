module Shoppe
  class Attachment < ApplicationRecord
    # Set the table name
    self.table_name = 'shoppe_attachments'

    # Mount the Carrierwave uploader
    mount_uploader :file, AttachmentUploader

    # Relationships
    belongs_to :parent, polymorphic: true

    # Validations
    validates :file_name, presence: true
    validates :file_type, presence: true
    validates :file_size, presence: true
    validates :file, presence: true
    validates :token, presence: true, uniqueness: true

    # All attachments should have a token assigned to this
    before_validation { self.token = SecureRandom.uuid if token.blank? }

    # Set the appropriate values in the model
    before_validation do
      if file
        self.file_name = file.filename if file_name.blank?
        self.file_type = file.content_type if file_type.blank?
        self.file_size = file.size if file_size.blank?
      end
    end

    # Return the attachment for a given role
    def self.for(role)
      where(role: role).first
    end

    # Return the path to the attachment
    def path
      file.url
    end

    # Is the attachment an image?
    def image?
      file_type.match(/\Aimage\//).present?
    end
  end
end
