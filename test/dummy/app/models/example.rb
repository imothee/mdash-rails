class Example < ApplicationRecord
  enum :status, { active: 0, inactive: 1 }

  scope :not_active, -> { where(status: :inactive) }
end
