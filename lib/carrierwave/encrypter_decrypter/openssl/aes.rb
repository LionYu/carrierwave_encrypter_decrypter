module Openssl
  module Aes
    def self.encrypt_existing_file_for(obj)
      begin 
        model = obj.model
        mounted_as = obj.mounted_as
        cipher = OpenSSL::Cipher::AES.new(Carrierwave::EncrypterDecrypter.configuration.key_size, :CBC)
        cipher.encrypt
        iv = cipher.random_iv
        model.iv = iv
        key = cipher.random_key
        model.key = key
        model.save!
        
        original_file_path = File.expand_path("#{obj.store_path}/#{obj.model.attributes['attachment']}", obj.root)
        encrypted_file_path = File.expand_path("#{obj.store_path}/#{obj.model.attributes['attachment']}", obj.root) + ".enc"
        buf = ""
        File.open(encrypted_file_path, "wb") do |outf|
          File.open(original_file_path, "rb") do |inf|
            while inf.read(4096, buf)
              outf << cipher.update(buf)
            end
            outf << cipher.final
          end
        end
        File.unlink(original_file_path)     
      rescue Exception => e  
        puts "****************************#{e.message}"
        puts "****************************#{e.backtrace.inspect}"
      end
    end

    def self.encrypt_for(obj, file_path)
      begin 
        model = obj.model
        mounted_as = obj.mounted_as
        cipher = OpenSSL::Cipher::AES.new(Carrierwave::EncrypterDecrypter.configuration.key_size, :CBC)
        cipher.encrypt
        iv = cipher.random_iv
        model.iv = iv
        key = cipher.random_key
        model.key = key
        model.save!
        
        original_file_path = file_path
        encrypted_file_path = file_path + ".enc"
        buf = ""
        File.open(encrypted_file_path, "wb") do |outf|
          File.open(original_file_path, "rb") do |inf|
            while inf.read(4096, buf)
              outf << cipher.update(buf)
            end
            outf << cipher.final
          end
        end
        File.unlink(original_file_path)
        return encrypted_file_path
      rescue Exception => e  
        puts "****************************#{e.message}"
        puts "****************************#{e.backtrace.inspect}"
      end
    end

    def self.decrypt_for(obj,opts)
      begin
        model = obj
        mounted_as = opts[:mounted_as]
        cipher = OpenSSL::Cipher::AES.new(Carrierwave::EncrypterDecrypter.configuration.key_size, :CBC)
        cipher.decrypt
        cipher.iv = model.iv 
        cipher.key = model.key
        buf = ""

        original_file_path = Tempfile.new(obj.attributes[mounted_as.to_s].remove(".ecn")).path
        encrypted_file_path =  obj.send(mounted_as).url

        File.open(original_file_path, "wb") do |outf|
          open(encrypted_file_path, "rb") do |inf|
            while inf.read(4096, buf)
              outf << cipher.update(buf)
            end
            outf << cipher.final
          end
        end
        original_file_path
      rescue Exception => e
        puts "****************************#{e.message}"
        puts "****************************#{e.backtrace.inspect}"
      end
    end
  end
end