class Task < ApplicationRecord
	default_scope -> { order(due_date: :asc) }

  belongs_to :recruit, inverse_of: :tasks
end
