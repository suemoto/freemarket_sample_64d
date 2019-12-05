require 'rails_helper'

describe User do
  describe '#create' do
    context 'can save' do
      # it "is valid with content" do
      #   message = build(:message, image: nil)
      #   expect(message).to be_valid
      # end

      # it "is valid with image" do
      #   message = build(:message, content: nil)
      #   expect(message).to be_valid
      # end

      # it "is valid with content and image" do
      #   message = build(:message)
      #   expect(message).to be_valid
      # end
    end

    context 'can not save' do
      context '〜がない場合' do
        it "family_nameがない場合、登録できない" do
          user = build(:user, family_name: nil)
          user.valid?
          expect(user.errors[:family_name]).to include("can't be blank")
        end

        it "first_nameがない場合、登録できない" do
          user = build(:user, first_name: nil)
          user.valid?
          expect(user.errors[:first_name]).to include("can't be blank")
        end

        it "family_name_kanaがない場合、登録できない" do
          user = build(:user, family_name_kana: nil)
          user.valid?
          expect(user.errors[:family_name_kana]).to include("can't be blank")
        end

        it "first_name_kanaがない場合、登録できない" do
          user = build(:user, first_name_kana: nil)
          user.valid?
          expect(user.errors[:first_name_kana]).to include("can't be blank")
        end
        
        it "nicknameがない場合、登録できない" do
          user = build(:user, nickname: nil)
          user.valid?
          expect(user.errors[:nickname]).to include("can't be blank")
        end
        
        it "emailがない場合、登録できない" do
          user = build(:user, email: nil)
          user.valid?
          expect(user.errors[:email]).to include("can't be blank")
        end
        
        it "passwordがない場合、登録できない" do
          user = build(:user, password: nil)
          user.valid?
          expect(user.errors[:password]).to include("can't be blank")
        end

        it "phone_numberがない場合、登録できない" do
          user = build(:user, phone_number: nil)
          user.valid?
          expect(user.errors[:phone_number]).to include("can't be blank")
        end

        it "birthdayがない場合、登録できない" do
          user = build(:user, birthday: nil)
          user.valid?
          expect(user.errors[:birthday]).to include("can't be blank")
        end

        it "credit_card_numberがない場合、登録できない" do
          user = build(:user, credit_card_number: nil)
          user.valid?
          expect(user.errors[:credit_card_number]).to include("can't be blank")
        end
      end
    end
  end
end