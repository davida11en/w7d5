# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  password_digest :string           not null
#  session_token   :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_session_token  (session_token)
#  index_users_on_username       (username)
#
class User < ApplicationRecord
    validates :username, :password_digest, :session_token, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true 
    validates :username, uniqueness: true

    before_validation :ensure_session_token
    
    attr_reader :password

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def reset_session_token! 
        self.session_token = SecureRandom::urlsafe_base64 
    end 

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user 
        else
            nil 
        end
    end

    private 
    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end
end
