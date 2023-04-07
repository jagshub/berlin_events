module EventsHelper
  def show_date(start_date = nil, end_date = nil)
    if start_date.present? && end_date.present? && start_date != end_date
      return [start_date.strftime('%B %d'), end_date.strftime('%B %d %Y')].join(' to ')
    end
    start_date.strftime('%B %d %Y')
  end
end
