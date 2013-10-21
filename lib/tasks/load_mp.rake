# encoding: UTF-8
require 'mps_downloader.rb'
namespace :kiwimp do

  task :download_nats => :environment do
    MpsDownloader.download_nats
  end

  desc 'download mp page urls from parliament.nz'
  task :download_mps => :environment do
    MpsDownloader.download
  end

  desc 'download mp images from parliament.nz'
  task :download_mp_images => :environment do
    image_path = RAILS_ROOT + '/public/images/mps/2007'
    Dir.mkdir image_path unless File.exist?(image_path)
    MpsDownloader.download_images image_path
  end

  desc "download former MPs from parliament.nz"
  task :download_former_mps => :environment do
    MpsDownloader.download_former
  end
end
