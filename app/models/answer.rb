class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_best!
    answer = question.answers.find_by(best: true)

    transaction do
      answer&.update!(best: false)
      update!(best: true)
    end
  end
end
