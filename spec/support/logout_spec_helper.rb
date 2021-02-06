# spec/support/controller_spec_helper.rb
module LogoutSpecHelper
    # generate tokens from user id



     def invalidate_generated_token(user_id)
        p user_id
      salt_record = Salt.where(user_id: user_id).take
      if salt_record == nil
        puts "null record"
      else
        salt_record.salt_str = random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
        salt_record.save
      end

    end

    # return valid headers
    def valid_headers
      {
        "Logout" => invalidate_generated_token(user_id),
        "Content-Type" => "application/json"
      }
    end

    # return invalid headers
    def invalid_headers_
      {
        "Logout" => nil,
        "Content-Type" => "application/json"
      }
    end
  end