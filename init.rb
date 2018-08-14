require 'redmine'

require_dependency 'report_sender'

Redmine::Plugin.register :report_sender do
  name 'Report Sender plugin'
  author 'Alex Andreiev'
  description 'This is a plugin for Redmine. The plugin are sending report via POST request to remote server when user modify task.'
  version '0.0.1'
  author_url 'https://github.com/alexckua'

  settings :default => {'callback_url' =>  'http://example.com/callback/'}, :partial => 'settings/report_settings'
end
