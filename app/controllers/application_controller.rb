class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_current_user

  # This method exists because devise is currently broken with HW Turbo
  def authenticate_user_hw!
    unless warden.authenticate
      flash[:notice] = "You need to be signed in to access this page!"
      redirect_to new_user_session_path
    end
  end

  def set_current_user
    Current.user = current_user if user_signed_in?
  end

  def set_admin_area
    raise ActionController::RoutingError.new("Not Found") unless current_user&.role? :admin
    @admin_area = true
  end

  def filter(records)
    @columns.find_all(&:filterable).each do |column|
      if column[:table].present?
        table = column[:table]
        value = session["#{column[:table]}___#{column[:name]}".to_sym]
      else
        table = records.table_name
        value = session[column[:name].to_sym]
      end

      if value.present?
        if column[:type] == "boolean"
          condition = "="
          search = value == "Yes"
        elsif column[:type] == "belongs_to"
          condition = "="
          search = value
        else
          condition = "ILIKE"
          # search = sanitize_sql_like("%#{value}%")
          search = "%#{value}%"
        end

        # records.where(Category.arel_table[:title].matches(search))
        records = records.where("#{table}.#{column[:name]} #{condition} ?", search)
      end
    end

    records
  end
end
