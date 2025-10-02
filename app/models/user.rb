class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, # cái này 
         :registerable, # đăng ký tài khoản mới 
         :recoverable, # reset passwork
         :rememberable, # ghi nhứo login bằng cokkie
         :validatable, # validate email và password
         :confirmable, # xác thực email
         :lockable,   # khoá sau nhiều lần login sai
         :jwt_authenticatable, # login bằng JWT
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end


# Các module trong Devise
# 1. :database_authenticatable

# Xác thực người dùng qua email/password được lưu trong DB.

# Password được hash bằng bcrypt (không lưu password gốc).

# Khi login, Devise sẽ so sánh password nhập vào với password hash trong DB.

# 2. :registerable

# Cho phép người dùng đăng ký tài khoản mới qua API.

# Cũng cho phép update / delete account của chính họ (nếu bạn không chặn).

# 3. :recoverable

# Cung cấp tính năng quên mật khẩu: gửi email reset password, tạo token reset.

# Khi người dùng click link trong email, họ sẽ đặt lại mật khẩu mới.

# 4. :rememberable

# Xử lý logic “Remember me” khi login.

# Thay vì nhập lại password mỗi lần, user có thể chọn “ghi nhớ đăng nhập” và Devise sẽ lưu token nhớ login.

# Dùng nhiều hơn trong web app, với API thì ít cần.

# 5. :validatable

# Devise sẽ tự động thêm validation cơ bản cho User model:

# Email phải đúng định dạng.

# Password tối thiểu 6 ký tự (có thể cấu hình lại).

# Bạn có thể override nếu muốn validation khác.

# 6. :jwt_authenticatable

# Đây là module từ devise-jwt, thay vì lưu session cookie thì Devise sẽ sinh JWT token.

# Token sẽ được gửi về client trong Authorization: Bearer <jwt> và kiểm tra ở các request sau.

# 7. jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

# Đây là cấu hình chiến lược revoke token (tức là làm cho token hết hiệu lực khi logout).

# Có 2 kiểu chính:

# Null: nghĩa là không revoke gì cả → token vẫn dùng được cho đến khi hết hạn (exp). Logout chỉ có nghĩa là client xoá token bên phía nó. (đơn giản nhưng kém an toàn hơn).

# JTIMatcher hoặc Denylist (tuỳ bạn implement): nghĩa là khi logout thì token bị vô hiệu hoá ngay lập tức. Dùng bảng trong DB để lưu token bị cấm. (an toàn hơn).