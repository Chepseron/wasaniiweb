# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string
#  last_name                :string
#  email                    :string
#  password_digest          :string
#  profile_image_uid        :string
#  birthday                 :date
#  country                  :string
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  email_confirmed          :boolean
#  email_confirmation_token :string
#  sign_in_count            :integer          default(0)
#  last_signed_in           :datetime
#  authentication_token     :string
#  provider                 :string
#  uid                      :string
#  provider_image_url       :string
#  password_reset_token     :string
#  password_reset_sent_at   :datetime
#  invitation_token         :string
#  user_role_id             :integer
#  content_provider         :boolean
#  newsletter               :boolean
#  banned                   :boolean
#  privacy_accepted         :boolean
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_slug   (slug) UNIQUE
#

class User < ApplicationRecord
  extend FriendlyId

  before_create :create_email_confirmation_token
  has_secure_password

  friendly_id :name, use: [:slugged, :history]

  has_many :artists, as: :parent, :dependent => :destroy
  has_many :managed_pages, class_name: "PageAdmin", foreign_key: :user_id, :dependent => :destroy
  has_many :managed_artists, through: :managed_pages, source: :page, source_type: 'Artist', :dependent => :destroy
  has_many :managed_businesses, through: :managed_pages, source: :page, source_type: 'Business', :dependent => :destroy
  has_many :businesses, as: :parent, :dependent => :destroy
  has_and_belongs_to_many :industries
  has_many :artist_fans, :dependent => :destroy
  has_many :fanned_artists, through: :artist_fans, source: :artist, :dependent => :destroy

  has_many :business_fans, :dependent => :destroy
  has_many :fanned_businesses, through: :business_fans, source: :business, :dependent => :destroy

  validates_presence_of :first_name, :last_name, :email, :country
  validates_uniqueness_of :email
  validates_format_of :email, :with => /@/, message: 'Please enter a valid email address'
  validates :password, length: { minimum: 8 }, if: :new_and_needed?

  validates :birthday,
   date: { after: Proc.new { Time.now - 100.years },before: Proc.new { Time.now - 16.years }, message: 'must be a validate date (you must be over 16 register)' },
   if: :date_present?

  dragonfly_accessor :profile_image

  validates_acceptance_of :privacy_accepted, :message => "must be accepted"

  def name
    "#{first_name} #{last_name}"
  end

  def new_and_needed?
    if self.new_record?
      return true
    elsif !password.blank?
      return true
    else
      return false
    end
  end

  def email_activate!
    self.email_confirmed = true
    self.email_confirmation_token = nil
    save!(:validate => false)
  end

  def accept_invite!
    self.email_confirmed = true
    self.email_confirmation_token = nil
    self.content_provider = true
    save!(:validate => false)
  end

  def self.from_omniauth(auth_hash)
    user = User.find_by_email(auth_hash['info']['email'])
    if user.nil?
      user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    end

    if user.new_record?
      user.first_name = auth_hash['info']['name'].split(' ').first
      user.last_name = auth_hash['info']['name'].split(' ').last
      user.email = auth_hash['info']['email']
      user.provider_image_url = auth_hash['info']['image']

      case auth_hash['provider']
      when 'facebook'
        user.birthday = Date.strptime(auth_hash[:extra][:raw_info][:birthday], "%m/%d/%Y")
      end

      user.email_confirmed = true unless user.email.nil?
      user.save!(validate: false)
    end

    user
  end

  def date_present?
    !birthday.nil?
  end

  def is_page_admin?(page)
    if self == page.parent || self.managed_artists.include?(page) || self.managed_businesses.include?(page)
      return true
    else
      return false
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def send_admin_invitation(artist)
    generate_token(:invitation_token)
    save!(validate: false)
    UserMailer.admin_invitation(self, artist).deliver
  end

  def add_as_page_admin(page)
    if self.managed_pages.collect(&:page).include?(page) || self.managed_pages.create!(page: page)
      send_admin_invitation(page)
      return true
    else
      return false
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def more_info_needed?
    country.nil? || !privacy_accepted?
  end

  private

  def has_industry?
    return errors.add(:industries, 'must select at least one') if industries.empty?
  end


  def create_email_confirmation_token
    if self.email_confirmation_token.blank?
      begin
        self[:email_confirmation_token] = SecureRandom.urlsafe_base64
      end while User.exists?(:email_confirmation_token => self[:email_confirmation_token])
    end
  end
end
