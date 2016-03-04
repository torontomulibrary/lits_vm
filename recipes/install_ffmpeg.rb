# Cookbook Name:: lits_vm
# Recipe:: install_ffmpeg
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Download and extract ffmpeg static source
tar_extract 'http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz' do
  target_dir '/usr/local'
  compress_char ''
  creates '/usr/local/ffmpeg-3.0-64bit-static'
end

# Make binary accessible to PATH
link '/usr/local/bin/ffmpeg' do
  to '/usr/local/ffmpeg-3.0-64bit-static/ffmpeg'
end