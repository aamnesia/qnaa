require 'rails_helper'

shared_examples_for 'voted' do
  let!(:model) { described_class.controller_name.classify.constantize }
  let!(:votable) { create(model.to_s.underscore.to_sym) }
  let!(:voter) { create(:user) }


  describe 'PATCH #vote_up' do
    before { login(voter) }

    it 'assigns the requested votable to @votable' do
      patch :vote_up, params: { id: votable }
      expect(assigns(:votable)).to eq votable
    end

    it 'set new vote' do
      expect { patch :vote_up, params: { id: votable, format: :json } }.to change { votable.rating }.by(1)
    end

    it 'tries to vote twice' do
      patch :vote_up, params: { id: votable }
      expect { patch :vote_up, params: { id: votable, format: :json } }.to_not change { votable.rating }
    end

    it 'returns data in json' do
      patch :vote_up, params: { id: votable, format: :json }
      expect(JSON.parse(response.body).keys).to eq %w(id rating)
    end
  end

  describe 'PATCH #vote_down' do
    before { login(voter) }

    it 'assigns the requested votable to @votable' do
      patch :vote_down, params: { id: votable }
      expect(assigns(:votable)).to eq votable
    end

    it 'set new vote down' do
      expect { patch :vote_down, params: { id: votable, format: :json } }.to change { votable.rating }.by(-1)
    end

    it 'tries to vote twice' do
      patch :vote_down, params: { id: votable }
      expect { patch :vote_down, params: { id: votable, format: :json } }.to_not change { votable.rating }
    end

    it 'returns data in json' do
      patch :vote_down, params: { id: votable, format: :json }
      expect(JSON.parse(response.body).keys).to eq %w(id rating)
    end
  end

  describe 'DELETE #cancel_vote' do
    before { login(voter) }

    it 'assigns the requested votable to @votable' do
      delete :cancel_vote, params: { id: votable }
      expect(assigns(:votable)).to eq votable
    end

    it 'cancel vote' do
      patch :vote_up, params: { id: votable, format: :json }
      expect { delete :cancel_vote, params: { id: votable, format: :json } }.to change{ votable.rating }.from(1).to(0)
    end

    it 'returns data in json' do
      patch :cancel_vote, params: { id: votable, format: :json }
      expect(JSON.parse(response.body).keys).to eq %w(id rating)
    end
  end
end
