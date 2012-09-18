require 'tlsmail'
require 'time'
require 'parseconfig'

email_config = ParseConfig.new('email.conf').params
from = email_config['from_address']
to = email_config['to_address']
p = email_config['p']

content = <<EOF
From: #{from}
To: #{to}
subject: TEST from ruby
Date: #{Time.now.rfc2822}


EOF

Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)  
Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp| 
  smtp.send_message(content, from, to)
end
