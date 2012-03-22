maintainer       "John Dyer"
maintainer_email "johntdyer@gmail.com"
license          "All rights reserved"
description      "Installs/Configures Enstratus agent"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "java"

%w{amazon centos fedora debian ubuntu}.each do |os|
  supports os
end

