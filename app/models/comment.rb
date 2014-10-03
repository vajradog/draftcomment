class Comment < ActiveRecord::Base
	belongs_to :post
	scope :approved, -> { where status: 'approved'}
  scope :draft, -> { where status: 'draft'}
end
