require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, :with_attachment, user: author) }
  let(:questions_file) { question.files.first }

  describe 'DELETE #destroy' do
    context 'Author tries to delete file in' do
      before { login(author) }

      it 'question' do
        expect { delete :destroy, params: { id: questions_file.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: questions_file.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete file in not his' do
      before { login(user) }

      it 'question' do
        expect { delete :destroy, params: { id: questions_file.id }, format: :js }.to_not change(question.files, :count)
      end

      it 'returns forbidden status' do
        delete :destroy, params: { id: questions_file.id }, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
