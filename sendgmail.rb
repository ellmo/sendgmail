#!/usr/bin/env ruby
require 'tlsmail'
require 'time'
require 'parseconfig'
require 'pry'

subject = ARGV[0]
filename = ARGV[1]
if filename
  filecontent = File.read(filename)
  encodedcontent = [filecontent].pack("m")   # base64
end

email_config = ParseConfig.new('email.conf').params
from = email_config['from_address']
to = email_config['to_address']
p = email_config['p']

content = <<EOF
From: #{from}
To: #{to}
subject: #{subject || 'no subject'} 
Date: #{Time.now.rfc2822}

#{encodedcontent}
EOF

Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)  
Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp| 
  smtp.send_message(content, from, to)
end
