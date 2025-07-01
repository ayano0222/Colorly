module ApplicationHelper
  def personal_color_name(code)
    case code
    when "spring", "スプリング" then "スプリング"
    when "summer", "サマー" then "サマー"
    when "autumn", "オータム" then "オータム"
    when "winter", "ウィンター" then "ウィンター"
    else "未設定"
    end
  end
end
