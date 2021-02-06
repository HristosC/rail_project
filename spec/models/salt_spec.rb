require 'rails_helper'

RSpec.describe Salt, type: :model do
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:salt_str) }
  it { should validate_presence_of(:token) }

end