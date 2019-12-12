class SignupController < ApplicationController

  require "payjp" #gemを読み込む。カード情報登録に必要

  def new
  end

  def signup1
    @user = User.new
  
  end

  def signup2
    session[:nickname] = params[:nickname]    #何故かuser_paramsで値取得できなかったので、paramsで取得
    session[:email] = params[:email]          #sessionに一時データを格納することでpage遷移が可能
    session[:password] = params[:password]
    session[:family_name] = params[:family_name]
    session[:first_name] = params[:first_name]
    session[:family_name_kana] = params[:family_name_kana]
    session[:first_name_kana] = params[:first_name_kana]
    session[:birthday] = date_params[:year]+date_params[:month]+date_params[:day]   #年、月、日を結合
    if verify_recaptcha   #「私はロボットではありません」にチェックがあれば実行
      @user = User.new
    else
      render '/signup/signup1'
    end
  end

  def signup3
    session[:phone_number] = user_params[:phone_number]
    @user = User.new
    @user.addresses.build    #この記述により、addressesテーブル用のfields_forフォームが、signup3に表示可能
  end

  def signup4
    @user = User.new
    session[:addresses_attributes] = user_params[:addresses_attributes] #住所テーブルのパラメータを一時保存
  end

  def create
    @user = User.new(
      nickname:         session[:nickname],
      email:            session[:email],
      password:         session[:password],
      password_confirmation: session[:password],
      family_name:      session[:family_name],
      first_name:       session[:first_name],
      family_name_kana: session[:family_name_kana],
      first_name_kana:  session[:first_name_kana],
      phone_number:     session[:phone_number],
      birthday:         session[:birthday],
    )
    @user.addresses.build(session[:addresses_attributes].first[1]) #addressesインスタンスを生成。usersインスタンスがsaveされると同時にsaveされる。
                                                                   #sessionのままだと何故かハッシュではなかったので、.first[1]でハッシュに変えています。興味あれば、コンソールで確認してみてください。

    if @user.save!
      session[:id] = @user.id
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"] #APIキーを使ってPayjpクラスを初期化
      customer = Payjp::Customer.create(  #pay.jsで生成された、カード情報を含んだトークンをPay.jp側に保存する。
        card: params['payjp-token']
      )
      @card = Card.create!(   #トークンとuserとを結びつける、cardsインスタンスを保存する。
        user_id: @user.id,    
        customer_id: customer.id,   #payjpの顧客id
        card_id: customer.default_card  #payjpのデフォルトカードid
      )
      redirect_to signup5_signup_index_path   #インスタンスの保存ができれば、登録完了ページへ遷移
    else
      render '/signup/signup1'  #登録に失敗すれば、入力ページ1へ移動
    end
  end

  def signup5
    sign_in User.find(session[:id]) unless user_signed_in?  #登録完了と同時にログインさせる。※sign_inはdeviseのコマンド
  end

  private
  def user_params
    params.require(:user).permit(
      :family_name,
      :first_name,
      :family_name_kana,
      :first_name_kana,
      :nickname,
      :email,
      :password,
      :phone_number,
      :birthday_year,
      :birthday_month,
      :birthday_day,
      addresses_attributes: [
        :id,
        :family_name,
        :first_name,
        :family_name_kana,
        :first_name_kana,
        :post_code,
        :prefecture_id,
        :city,
        :street_number,
        :building_name,
        :phone_number
      ]
    )
  end

  def date_params
    params.require(:date).permit(
      :year,
      :month,
      :day
    )
  end
end
