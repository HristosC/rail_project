# app/lib/json_web_token.rb
class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # set expiry to 24 hours from creation time
	if payload[:user_id] != nil
    salt_record = Salt.where(user_id: payload[:user_id]).take
    payload[:exp] = exp.to_i
    if salt_record == nil
      random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      token = JWT.encode(payload, random_salt)
      salt_record = Salt.create!(user_id: payload[:user_id], salt_str: random_salt, token: token)
      salt_record.token
    else
      salt_record.salt_str = random_salt = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      token = JWT.encode(payload, salt_record.salt_str)
      salt_record.token = token
      salt_record.save
      token
    end
  else
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end
  end

  def self.decode(token)
	salt_record = Salt.where(token: token).take
    if salt_record == nil
      raise ExceptionHandler::InvalidToken, "Not enough or too many segments"
    else
    # get payload; first index in decoded Array
    body = JWT.decode(token, salt_record.salt_str)[0]
    HashWithIndifferentAccess.new body
	end
    # rescue from all decode errors
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    raise ExceptionHandler::InvalidToken, e.message
  end
    def self.invalidate(token)
    #p user_id
    salt_record = Salt.where(token: token).take
    #p salt_record
    if salt_record == nil
      return nil
    else
      salt_record.salt_str =  (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      salt_record.save
      return 200
    end
  end
end