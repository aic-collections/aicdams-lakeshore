class User < ActiveRecord::Base
  include Blacklight::User
  include Hydra::User
  include Sufia::User
  include Sufia::UserUsageStats
  include Hydra::RoleManagement::UserRoles

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed :registerable to prevent users from self-signup
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def admin?
    ADMINS.include?(email)
  end

  def groups
    groups = super
    groups += ["admin"] if admin?
    groups
  end
end
