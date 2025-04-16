module Admin::VillasHelper
  def status_tag(status)
    case status
    when 'available'
      content_tag(:span, status.titleize, class: 'badge bg-success')
    when 'disabled'
      content_tag(:span, status.titleize, class: 'badge bg-danger')
    else
      content_tag(:span, status.titleize, class: 'badge bg-secondary')
    end
  end
end
