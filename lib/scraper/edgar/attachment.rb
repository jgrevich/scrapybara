module Scraper
  class Edgar
    class Attachment
      
      ### mongoid config
      include Mongoid::Document
      include Mongoid::Timestamps
      
    #  include Mongoid::Paperclip

      field :cik, type: Integer
      field :accession_number, type: String
      field :sequence, type: Integer
      field :description, type: String
      field :document_name, type: String
      field :document_type, type: String
      field :document_data, type: Moped::BSON::Binary
      field :filing_id, type: String
#      validates_uniqueness_of :sequence, :scope => :filing 
   # will use if this makes it to rails    
   #  has_mongoid_attached_file :document
      embedded_in  :filing, :inverse_of => :attachments
      
      def to_s
        "@sequnce: #{@sequence} @description: #{@description} @document_name: #{@document_name} @document_type: #{@document_type} | filing: #{filing}"
      end
    end
  end
end