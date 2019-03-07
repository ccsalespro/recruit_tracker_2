class SearchRecruits < CommandModel::Model
  parameter :q
  parameter :closed

  attr_reader :rows

  def execute
    @rows = Recruit.all
    if closed.present?
      @rows = @rows.where(closed: closed)
    else
      @rows = @rows.where(closed: false)
    end
    if q.present?
      recruit_fields = %w[name phone_number email description]
      @rows = @rows.where(recruit_fields.map { |f| "recruits.#{f} ilike :q" }.join(" or "), q: "%#{q}%")
    end
    @rows
  end
end
