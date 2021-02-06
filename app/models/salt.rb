class Salt < ApplicationRecord
    validates_presence_of :user_id, :salt_str, :token
end