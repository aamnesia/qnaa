class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: [:destroy, :update, :set_best]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def set_best
    @question = @answer.question
    @answer.set_best! if current_user.author?(@answer)
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
