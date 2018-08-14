require 'rubygems'
require 'net/http'
require 'json'

class Report < ActiveRecord::Base
  def self.send_issue_update(userId, issue, journal)
    post_to_server({
      "issueid" => issue.id,
      "userid" => userId,
      "datetime" => issue.updated_on,
      "report" => generate_report(journal)
    })
  end

  private

  def self.callback_url()
    return Setting.plugin_report_sender["callback_url"]
  end

  def self.callback_port()
    return Setting.plugin_report_sender["callback_port"]
  end

  def self.post_to_server(data)
    uri = URI(callback_url)
    uri.port = callback_port
    http =  Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = data.to_json
    res = http.request(req)
  end

  def self.generate_report(journal)
    return if journal.details.blank?

    new_val = String.new
    old_val = String.new
    chars = String.new
    chars_hash = Hash.new(0)

    journal.details.each do |j|
      new_val << j.value if j.value
      old_val << j.old_value if j.old_value
    end

    changes = new_val.diff(old_val).diffs.flatten(1)
    changes.each{ |change_arr| chars << change_arr[2] }

    scount = chars.length
    wcount = new_val.split(/[ .,-]/).diff(old_val.split(/[ .,-]/)).diffs.flatten(1).length

    chars.each_char{ |c| chars_hash[c] += 1 unless c == " " }
    max_used_char = chars_hash.max_by{ |key, value| value }

    report = {
      "scount" => scount,
      "wcount" => wcount,
      "mused" => max_used_char[0]
    }
  end
end
