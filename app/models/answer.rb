class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

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
