require 'spec_helper'

RSpec.describe LeaderboardNotificationMailer, type: :mailer, api: true do

  describe 'methods' do
    let!(:challenge) { create :challenge, :running }
    let!(:participant) { create :participant }
    let!(:email_preference) {
      create :email_preference,
      :every_email,
      participant: participant }
    let!(:submission) {
      create :submission,
      challenge: challenge,
      participant: participant }

    it 'successfully sends a message' do
      res = described_class.new.sendmail(participant.id,submission.id)
      man = MandrillSpecHelper.new(res)
      expect(man.status).to eq 'sent'
      expect(man.reject_reason).to eq nil
    end

    it 'addresses the email to the participant' do
      res = described_class.new.sendmail(participant.id,submission.id)
      man = MandrillSpecHelper.new(res)
      expect(man.merge_var('NAME')).to eq(participant.name)
    end

    it 'produces a body which is correct HTML' do
      res = described_class.new.sendmail(participant.id,submission.id)
      man = MandrillSpecHelper.new(res)
      expect(man.merge_var('BODY')).to be_a_valid_html_fragment
    end

    it 'produces a valid leaderboard link' do
      leaderboard_link = described_class.new.leaderboard_link(submission)
      expect(leaderboard_link).to be_a_valid_html_fragment
      expect(leaderboard_link).to include(ENV['HOST'])
    end
  end

end
