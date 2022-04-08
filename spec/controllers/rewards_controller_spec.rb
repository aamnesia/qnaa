require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:rewards) { create_list(:reward, 2, question: question, user: user) }

  describe 'GET #index' do
    context 'Rewarded user' do
      before { login(user) }
      before { get(:index) }

      it 'populates an array of user rewards' do
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Not rewarded user' do
        before { login(create(:user)) }
        before { get :index }

        it 'doesnt populate an array of rewards' do
          expect(assigns(:rewards)).to be_empty
        end

        it 'renders index view' do
          expect(response).to render_template :index
        end
      end

      context 'Unauthorized user' do
        before { get :index }

        it 'doesnt populates an array of rewards' do
          expect(assigns(:rewards)).to eq nil
        end
      end
  end
end
