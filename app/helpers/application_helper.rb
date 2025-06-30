module ApplicationHelper
  def personal_color_name(code)
    case code
    when "スプリング" then "スプリング"
    when "サマー" then "サマー"
    when "オータム" then "オータム"
    when "ウィンター" then "ウィンター"
    else "未設定"
    end
  end
end
