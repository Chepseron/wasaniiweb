# == Schema Information
#
# Table name: books
#
#  id                    :integer          not null, primary key
#  title                 :string
#  isbn                  :string
#  cover_pic_uid         :string
#  summary               :text
#  publishing_company_id :integer
#  publishing_date       :date
#  parent_id             :integer
#  parent_type           :string
#  aasm_state            :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_books_on_slug  (slug)
#

class Book < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title summary)

  validates_presence_of :title, :summary, :publishing_date

	belongs_to :parent, polymorphic: :true
  belongs_to :publishing_company, class_name: 'Business', optional: true
  has_many :collection_entities, as: :entity, :dependent => :destroy
  has_and_belongs_to_many :life_events
  has_many :awards, as: :recipient
  has_many :impressions, as: :entity, dependent: :destroy

  validate :valid_publishing_company

  friendly_id :title, use: [:slugged, :history]
  dragonfly_accessor :cover_pic

  default_scope -> {order('created_at desc')}
  scope :published, lambda{where(:aasm_state => 'published')}
  scope :verified, lambda { where(:parent => true) }

  def country
    ISO3166::Country.find_country_by_alpha2(parent.country_of_birth).name
  end

  def date
    publishing_date
  end

  def valid_publishing_company
    if publishing_company_id == -1
      errors.add(:publishing_company_name, 'must be an existing company')
      self[:publishing_company_id] = nil
    end
  end

  def publishing_company_name=(val)
    begin
      self[:publishing_company_id] = Business.find_by_name(val).id unless val.blank?
    rescue
      self[:publishing_company_id] = -1

    end
  end

  def publishing_company_name
    Business.find(publishing_company_id).name if publishing_company_id
  end

  def self.trending
    return Impression.where(entity_type: 'Book').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|book_id,count| Book.find_by_id(book_id).parent}.compact
  end

  def self.viewable
    all.collect do |book|
      book if book.aasm_state == 'published' || book.parent.verified
    end.compact
  end
end
