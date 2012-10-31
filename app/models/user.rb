class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :old_password
  attr_accessor :old_password

  validates :name, presence: true, uniqueness: true
  validate :confirm_current_password, on: :update
  has_secure_password

  after_destroy :ensure_an_admin_remains

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise "Can't delete last user"
      end
    end

    def confirm_current_password
      if password_digest_changed? and BCrypt::Password.new(password_digest_was) != old_password
        errors.add(:old_password, "%{attribute} does not match #{old_password}")
      end
    end
end
