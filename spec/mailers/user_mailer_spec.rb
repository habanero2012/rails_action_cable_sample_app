require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:from_address) { 'noreply@example.com' }

  describe 'account_activation' do
    let(:user) { build(:user, activation_token: User.new_token) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([from_address])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
      expect(mail.body.encoded).to match(CGI.escape(user.email))
      expect(mail.body.encoded).to match(user.activation_token)
    end
  end

  describe 'password_reset' do
    let(:user) { build(:user, reset_token: User.new_token) }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([from_address])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Password reset')
      expect(mail.body.encoded).to match(CGI.escape(user.email))
      expect(mail.body.encoded).to match(user.reset_token)
    end
  end

end
