#
# Cookbook Name:: lits_vm
# Resource:: user
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

default_action :create
actions :create, :remove

property :username, String, name_property: true
property :uid, Integer
property :gid, Integer
property :password, String
property :salt, String
property :ssh_keys, Array
property :ssh_private_key, String
property :ssh_public_key, String
property :authorized_keys_file, String
property :shell, String
property :comment, String
property :home, String
property :sudo, [true, false], default: false
property :data_bag, String, default: 'users'
property :cookbook, String, default: 'lits_vm'


action :create do
  # Set home to location in data bag,
  # or a reasonable default ($home_basedir/$user).
  home_dir = (new_resource.home || "#{home_basedir}/#{new_resource.username}")
  
  # check whether home dir is null
  manage_home = !(home_dir == '/dev/null')
  
  # The user block will fail if the group does not yet exist.
  # See the -g option limitations in man 8 useradd for an explanation.
  # This should correct that without breaking functionality.
  group new_resource.username do # ~FC022
    case node['platform_family']
    when 'mac_os_x'
      gid validate_id(new_resource.gid) unless gid_used?(validate_id(new_resource.gid)) || new_resource.group_name == u['username']
    else
      gid validate_id(new_resource.gid)
    end
    only_if { new_resource.gid && new_resource.gid.is_a?(Numeric) }
  end

  # Create the user or update the user to match if it already exists.
  user new_resource.username do
    shell shell_is_valid?(new_resource.shell) ? new_resource.shell : '/bin/sh'
    comment new_resource.comment
    password new_resource.password if new_resource.password
    salt new_resource.salt if new_resource.salt
    manage_home manage_home
    home home_dir
    action :create
  end

  if manage_home_files?(home_dir, new_resource.username)
    Chef::Log.debug("Managing home files for #{new_resource.username}")

    directory "#{home_dir}/.ssh" do
      recursive true
      owner new_resource.uid ? validate_id(new_resource.uid) : new_resource.username
      group validate_id(new_resource.gid) if new_resource.gid
      mode '0700'
      only_if { !!(new_resource.ssh_keys || new_resource.ssh_private_key || new_resource.ssh_public_key) }
    end

    # loop over the keys and if we have a URL we should add each key
    # from the url response and append it to the list of keys
    ssh_keys = []
    if new_resource.ssh_keys
      Array(new_resource.ssh_keys).each do |key|
        if key.start_with?('https')
          ssh_keys += keys_from_url(key)
        else
          ssh_keys << key
        end
      end
    end

    # use the keyfile defined in the databag or fallback to the standard file in the home dir
    key_file = new_resource.authorized_keys_file || "#{home_dir}/.ssh/authorized_keys"

    template key_file do # ~FC022
      source 'authorized_keys.erb'
      cookbook new_resource.cookbook
      owner new_resource.uid ? validate_id(new_resource.uid) : new_resource.username
      group validate_id(new_resource.gid) if new_resource.gid
      mode '0600'
      sensitive true
      # ssh_keys should be a combination of u['ssh_keys'] and any keys
      # returned from a specified URL
      variables ssh_keys: ssh_keys
      only_if { !!(new_resource.ssh_keys) }
    end

    if new_resource.ssh_private_key
      key_type = new_resource.ssh_private_key.include?('BEGIN RSA PRIVATE KEY') ? 'rsa' : 'dsa'
      template "#{home_dir}/.ssh/id_#{key_type}" do
        source 'private_key.erb'
        cookbook new_resource.cookbook
        owner new_resource.uid ? validate_id(new_resource.uid) : new_resource.username
        group validate_id(new_resource.gid) if new_resource.gid
        mode '0400'
        variables private_key: new_resource.private_key
      end
    end

    if new_resource.ssh_public_key
      key_type = new_resource.ssh_public_key.include?('ssh-rsa') ? 'rsa' : 'dsa'
      template "#{home_dir}/.ssh/id_#{key_type}.pub" do
        source 'public_key.pub.erb'
        cookbook new_resource.cookbook
        owner new_resource.uid ? validate_id(new_resource.uid) : new_resource.username
        group validate_id(new_resource.gid) if new_resource.gid
        mode '0400'
        variables public_key: u['ssh_public_key']
      end
    end
  else
    Chef::Log.debug("Not managing home files for #{u['username']}")
  end
end

action :remove do
  user new_resource.username do
    action :remove
  end
end

action_class do
  ## From: https://github.com/chef-cookbooks/users/blob/273088d712d0d74ebb1f15693283abb97c3250b9/libraries/helpers.rb#L33
  ## Checks fs type.
  #
  # @return [String]
  def fs_type(mount)
    # Doesn't support macosx
    stat = Mixlib::ShellOut.new("stat -f -L -c %T #{mount} 2>&1").run_command
    stat.stdout.chomp
  rescue
    'none'
  end

  # Determines if provided mount point is remote.
  #
  # @return [Boolean]
  def fs_remote?(mount)
    fs_type(mount) == 'nfs'
  end

  def keys_from_url(url)
    host = url.split('/')[0..2].join('/')
    path = url.split('/')[3..-1].join('/')
    begin
      response = Chef::HTTP.new(host).get(path)
      response.split("\n")
    rescue Net::HTTPServerException => e
      p "request: #{host}#{path}, error: #{e}"
    end
  end

  # Determines if the user's shell is valid on the machine, otherwise
  # returns the default of /bin/sh
  #
  # @return [String]
  def shell_is_valid?(shell_path)
    return false if shell_path.nil? || !::File.exist?(shell_path)
    # AIX is the only OS that has the concept of 'approved shells'
    return true unless platform_family?('aix')

    begin
      File.open('/etc/security/login.cfg') do |f|
        f.each_line do |l|
          l.match(/^\s*shells\s*=\s*(.*)/) do |m|
            return true if m[1].split(/\s*,\s*/).any? { |entry| entry.eql? shell_path }
          end
        end
      end
    rescue
      return false
    end

    false
  end

  # Validates passed id.
  #
  # @return [Numeric, String]
  # handles checking whether uid was specified as a string
  def validate_id(id)
    id.to_i.to_s == id ? id.to_i : id
  end

  # Returns the appropriate base user home directory per platform
  #
  # @return [ String]
  def home_basedir
    if platform_family?('mac_os_x')
      '/Users'
    elsif platform_family?('solaris2')
      '/export/home'
    else
      '/home'
    end
  end

  def manage_home_files?(home_dir, _user)
    # Don't manage home dir if it's NFS mount
    # and manage_nfs_home_dirs is disabled
    if home_dir == '/dev/null'
      false
    elsif fs_remote?(home_dir)
      new_resource.manage_nfs_home_dirs ? true : false
    else
      true
    end
  end
end