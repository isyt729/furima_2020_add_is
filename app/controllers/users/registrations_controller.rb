class Users::RegistrationsController < Devise::RegistrationsController
 
  def new
    @user = User.new
  end

  def create
    if params[:sns_auth] == 'true'
      pass = Devise.friendly_token
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
    end

    build_resource(sign_up_params)

     unless @user.valid?
       @sns_id = "tmp"
       render :new and return
     end
     
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    @address = @user.build_address
    render :new_address 
  end

  def create_address
    @user = User.new(session["devise.regist_data"]["user"])
    @address = Address.new(address_params)
    unless @address.valid?
      render :new_address and return
     end
     
    @user.build_address(@address.attributes)
    @user.save
    session["devise.regist_data"]["user"].clear
    sign_in(:user, @user)
    redirect_to root_path
  end
 
  protected
 
  def address_params
    params.require(:address).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number)
  end
end
