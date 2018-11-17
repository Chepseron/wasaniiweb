module EntityState
  extend ActiveSupport::Concern

  included do
    include AASM
    aasm do
      state :new_entity, :initial => true
      state :unreviewed
      state :rejected
      state :approved
      state :published
      state :unpublished

      event :approve do
        transitions from: [:new_entity, :unreviewed, :approved, :rejected, :published, :rejected, :unpublished], to: :published
      end

      event :publish do
        transitions from: [:new_entity, :unreviewed, :approved, :rejected, :published, :rejected, :unpublished], to: :published
      end

      event :reject do
        transitions from: [:new_entity, :unreviewed, :approved, :rejected, :published, :rejected, :unpublished], to: :rejected
        after do
          self.impressions.delete_all
          ArtistMailer.rejected(self).deliver
        end
      end

      event :unpublish do
        transitions from: [:new_entity, :unreviewed, :approved, :rejected, :published, :rejected, :unpublished], to: :unpublished
        after do
          self.impressions.delete_all
          ArtistMailer.rejected(self).deliver
        end
      end
    end
  end
end
