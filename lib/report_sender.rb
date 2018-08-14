require 'rubygems'

class ReportSender < Redmine::Hook::Listener
  def controller_issues_edit_after_save(context={})
    if context[:issue] && context[:journal] && context[:params]
      Report.send_issue_update(User.current.id, context[:issue], context[:journal])
    end
  end
end

