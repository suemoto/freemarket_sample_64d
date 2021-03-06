class CardsController < ApplicationController
  before_action :authenticate_user!
  require "payjp" 

  def new
  end

  def create
    Payjp.api_key = Rails.application.credentials[:payjp_private_key] #APIキーを使ってPayjpクラスを初期化 (本番環境用)
    customer = Payjp::Customer.create()#pay.jsサイトで顧客IDを生成、取得。
    card = customer.cards.create( #カードトークンをpay.jsサイトに登録し、カードidをpay.jsサイトから取得。
      card: params[:payjpToken]
    )
    Card.create(   #顧客id, カードidと、userとを結びつける、cardsインスタンスを保存する。
      user_id: current_user.id,    
      customer_id: customer.id,   #payjpの顧客id
      card_id: card.id  #payjpのカードid 
    )
    redirect_to "/users/mypage"
  end

  def registration
  end

  def show
    card = Card.where(user_id: current_user.id).first
    if card
      Payjp.api_key = Rails.application.credentials[:payjp_private_key]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  def destroy
    card = Card.where(user_id: current_user.id).first
    customer = Payjp::Customer.retrieve(card.customer_id)
    customer.delete
    card.destroy
    redirect_to registration_cards_path
  end

end