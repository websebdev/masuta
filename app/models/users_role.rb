# == Schema Information
#
# Table name: users_roles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_users_roles_on_role_id  (role_id)
#  index_users_roles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (user_id => users.id)
#
class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates :user, uniqueness: {scope: :role}
end
