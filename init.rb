require 'redmine'
require 'iruinai_hook'
require 'iruinai_application_helper_patch'

Redmine::Plugin.register :redmine_iruinai do
  name 'Redmine Iruinai plugin'
  author 'OZAWA Yasuhiro'
  description 'Show project member attendance.'
  version '0.0.3'
  url 'https://github.com/ameya86/redmine_iruinai'
  author_url 'http://blog.livedoor.jp/ameya86/'
end
