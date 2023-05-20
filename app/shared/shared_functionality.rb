# app/shared/shared_functionality.rb
module SharedFunctionality
    
  def admin_milk
    milks = Milk.all
    overall_admin_totals = milks.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }

    monthly_admin_totals = {}
    start_date = Date.new(2023, 1, 1)
    end_date = Date.new(2023, 12, 31)

    (start_date..end_date).each do |date|
      start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
      end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

      monthly_sells = milks.where(date: start_date_str..end_date_str)
      monthly_admin_totals[date.strftime("%B")] = monthly_sells.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }
    end

    render json: { message: "Milk records sorted by month and admin", overall_admin_totals: overall_admin_totals, monthly_admin_totals: monthly_admin_totals }
  end
end
