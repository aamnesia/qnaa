require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'voted'

  describe 'POST #create' do
    let(:answer) { attributes_for(:answer) }

    context 'Authenticated user creates answer with valid attributes' do
      before { login(user) }
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers.where(user: user), :count).by(1)
      end

      it 'redirect to its question show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'Authenticated user creates answer with invalid attributes' do
      before { login(user) }
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders its question show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'Not authenticated user tries to create answer' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author edits answer with valid attributes' do
      before { login(user) }
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author edits answer with invalid attributes' do
      before { login(user) }
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not author tries to edit answer' do
      let(:not_author) { create(:user) }
      before{ login(:not_author) }

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author tries to delete his answer' do
      before { login(user) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete someones answer' do
      before { login(create(:user)) }
      it 'doesnt delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #set_best' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context "Questions author chooses best answer" do
      before { login(user) }

      it 'sets answer as the best' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context "Not questions author tries to choose best answer" do
      before { login(create(:user)) }

      it 'doesnt set answer as the best' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end
