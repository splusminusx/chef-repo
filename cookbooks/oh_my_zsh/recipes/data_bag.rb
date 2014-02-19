#
# Cookbook Name:: oh_my_zsh
# Recipe:: data_bag
#

user_list = node['oh_my_zsh']['user_list']

if user_list.any?
  package "zsh"
  include_recipe "git"
end

# for each listed user
user_list.each do |user_name|

  user_hash = data_bag_item('oh_my_zsh', user_name)

  home_directory = data_bag_item(default['user']['data_bag_name'], user_name)['home']

  if home_directory.empty?
    home_directory = `cat /etc/passwd | grep "#{user_hash['login']}" | cut -d ":" -f6`.chop
  end

  git "#{home_directory}/.oh-my-zsh" do
    repository 'git://github.com/robbyrussell/oh-my-zsh.git'
    user user_hash['login']
    reference "master"
    action :sync
  end

  template "#{home_directory}/.zshrc" do
    source "zshrc.erb"
    owner user_hash['login']
    mode "644"
    action :create_if_missing
    variables({
      :user => user_hash['login'],
      :theme => user_hash['theme'] || 'robbyrussell',
      :case_sensitive => user_hash['case_sensitive'] || false,
      :plugins => user_hash['plugins'] || %w(git)
    })
  end

  user user_hash['login'] do
    action :modify
    shell '/bin/zsh'
  end

  execute "source /etc/profile to all zshrc" do
    command "echo 'source /etc/profile' >> /etc/zsh/zprofile"
    not_if "grep 'source /etc/profile' /etc/zsh/zprofile"
  end

end
