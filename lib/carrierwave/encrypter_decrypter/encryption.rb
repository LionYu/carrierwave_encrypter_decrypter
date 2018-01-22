require 'carrierwave/encrypter_decrypter/openssl/aes'
require 'carrierwave/encrypter_decrypter/openssl/pkcs5'

class Encryption
  def self.start!(obj, file_path)
    encryption_type = Carrierwave::EncrypterDecrypter.configuration.encryption_type

    case encryption_type
    when :aes
      Openssl::Aes.encrypt_for(obj, file_path)
    # when :pkcs5
    #   Openssl::Pkcs5.encrypt_for(obj)
    end
  end

  def self.encrypt_existing_file_start!(obj)
    encryption_type = Carrierwave::EncrypterDecrypter.configuration.encryption_type

    case encryption_type
    when :aes
      Openssl::Aes.encrypt_existing_file_for(obj)
    end
  end
end
