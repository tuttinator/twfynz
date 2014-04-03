# encoding: UTF-8
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  login           :string(255)
#  hashed_password :string(255)
#  email           :string(255)
#  salt            :string(255)
#  blog_url        :string(255)
#  site_url        :string(255)
#  email_confirmed :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

require 'digest/sha1'

class OrganisationUser < User

  before_validation :normalize_site_url,
      :check_email_domain_matches_site_url_domain,
      :create_login_from_site_url_domain,
      :set_email_confirmed_to_false

  validates_uniqueness_of :site_url
  validates_format_of :site_url, :with => /^((?:[-a-z0-9_]+\.)+[a-z]{2,})$/

  attr_protected :login, :email_confirmed

  protected

    def normalize_site_url
      if site_url
        self.site_url.chomp!('/')
        self.site_url.sub!('http://','')
      end
    end

    def check_email_domain_matches_site_url_domain
      if site_url && email && email.include?('@')
        domain = email.split('@')[1]
        if domain != site_url
          errors.add(:email, "should match site_url domain" )
          valid = false
        end
      end
    end

    def create_login_from_site_url_domain
      if site_url
        self.login = site_url.gsub('.','_')
      end
    end

    def set_email_confirmed_to_false
      self.email_confirmed = 0
    end

end
