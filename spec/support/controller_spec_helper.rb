# spec/support/controller_spec_helper.rb
module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
	if user_id != nil
    payload = Hash.new
    payload[:user_id] = user_id
    salt_record = Salt.where(user_id: user_id).take
    if salt_record == nil
      random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      token = JWT.encode(payload, random_salt)
      salt_record = Salt.create!(user_id: user_id, salt_str: random_salt, token: token)
      salt_record.token
    else
      salt_record.salt_str = random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      token = JWT.encode(payload, salt_record.salt_str)
      salt_record.token = token
      salt_record.save
      salt_record.token
    end
	else
		JsonWebToken.encode(user_id: user_id)
  end
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
        if user_id != nil
    payload = Hash.new
    payload[:user_id] = user_id
    payload[:exp] = Time.now.to_i - 10
    salt_record = Salt.where(user_id: user_id).take
    if salt_record == nil
      random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      token = JWT.encode(payload, random_salt)
      salt_record = Salt.create!(user_id: user_id, salt_str: random_salt, token: token)
      salt_record.token
    else
      salt_record.salt_str = random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      token = JWT.encode(payload, salt_record.salt_str)
      salt_record.token = token
      salt_record.save
      salt_record.token
    end
  else
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  end


  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end