class Recruit < ApplicationRecord

	has_many :messages, dependent: :destroy
  has_many :tasks, inverse_of: :recruit, dependent: :destroy
  accepts_nested_attributes_for :tasks

  default_scope -> { order(closed: :asc) }

	if joins(:tasks).count > 0
	  default_scope -> {
	    joins(:tasks).order("tasks.due_date")
	  }
	end

	def percent_complete
		((DateTime.now - start_date).to_f / ( (start_date + 1.month) - start_date).to_f) * 100
	end

end
