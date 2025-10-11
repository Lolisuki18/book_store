class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET_KEY'] || Rails.application.secret_key_base
  ACCESS_TOKEN_EXPIRY = ENV['JWT_ACCESS_EXPIRY'] 
  REFRESH_TOKEN_EXPIRY = ENV['JWT_REFRESH_EXPIRY'] 
  
  def self.encode(payload, exp = ACCESS_TOKEN_EXPIRY)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded 
    #Là để bạn có thể truy cập dữ liệu trong decoded bằng cả kiểu chuỗi ("key") và kiểu symbol (:key).
  rescue JWT::DecodeError
    nil
  end

  #Token sẽ trả về dạng mảng gồm 
  # [
  #   { "user_id" => 123 },         # payload
  #   { "alg" => "HS256", ... }     # header
  # ]
  # -> nếu muốn lấy payload thì lấy phần tử đầu tiên của mảng
end