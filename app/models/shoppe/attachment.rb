module Shoppe
  class Attachment < ActiveRecord::Base
  
    # Set the table name
    self.table_name = "shoppe_attachments"

    mount_uploader :file, AttachmentUploader

    # Relationships
    belongs_to :parent, :polymorphic => true

    # Validations
    validates :file_name, :presence => true
    validates :file_type, :presence => true
    validates :file_size, :presence => true
    validates :file, :presence => true
    validates :token, :presence => true, :uniqueness => true

    # All attachments should have a token assigned to this
    before_validation { self.token = SecureRandom.uuid if self.token.blank? }

    # Set the appropriate values in the model
    before_validation do
      if self.file
        self.file_name = self.file.filename if self.file_name.blank?
        self.file_type = self.file.content_type if self.file_type.blank?
        self.file_size = self.file.size if self.file_size.blank?
      end
    end

    # Return the attachment for a given role
    def self.for(role)
      self.where(:role => role).first
    end

    # Return the path to the attachment
    def path
      file.url
    end

    # Is the attachment an image?
    def image?
      if file_type.match(/\Aimage\//)
        true
      else
        false
      end
    end

    # Creates attachments for an item on the provided hash
    #
    # @param array [Array]
    def self.update_from_array(array)
      array.each do |hash|
        if hash["file"].is_a?(ActionDispatch::Http::UploadedFile)
          self.create(hash)
        end
      end
      true
    end

  end
end