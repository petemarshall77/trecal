class Photo < ApplicationRecord
  has_one_attached :image

  validates :taken_on, presence: true, uniqueness: true
  validates :image, presence: true

  validate :taken_on_not_in_future
  validate :image_content_type

  scope :chronological,         -> { order(:taken_on) }
  scope :reverse_chronological, -> { order(taken_on: :desc) }
  scope :for_month, ->(year, month) {
    where(taken_on: Date.new(year, month, 1)..Date.new(year, month, -1))
  }

  def self.for_date(date)    = find_by(taken_on: date)
  def self.previous_photo(d) = where("taken_on < ?", d).order(taken_on: :desc).first
  def self.next_photo(d)     = where("taken_on > ?", d).order(:taken_on).first

  private

  def taken_on_not_in_future
    errors.add(:taken_on, "cannot be in the future") if taken_on.present? && taken_on > Date.current
  end

  def image_content_type
    return unless image.attached?
    allowed = %w[image/jpeg image/png image/gif image/webp image/heic image/heif]
    errors.add(:image, "must be a JPEG, PNG, GIF, WebP, or HEIC file") unless image.content_type.in?(allowed)
  end
end
