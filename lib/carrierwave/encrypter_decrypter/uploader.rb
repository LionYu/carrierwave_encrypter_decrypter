#Carrierwave::EncrypterDecrypter::Uploader.encrypt("ank")
require 'carrierwave/encrypter_decrypter/encryption.rb'
module Carrierwave
  module EncrypterDecrypter
    module Uploader
      def self.encrypt(obj, file_path)
        Encryption.start!(obj, file_path)
      end

      def self.encrypt_existing_file_for(obj)
        Encryption.encrypt_existing_file_start!(obj)
      end
    end
  end
end
