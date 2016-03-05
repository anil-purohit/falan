class Api::V1::UsersController < Api::MainController

  def show
    id = params[:id].to_i
    create_response(400, "Invalid User Id.") if id <=0

    user = User.where(:id => params[:id])
    if user.present?
      create_response(200, user)
    else
      create_response(400, "Invalid User Id")
    end
  end


  # POST request to create user.
  # Request Payload with mandatory params
  # {
  #     "email_id" : "anilpurohit711@gmail.com",
  #     "signup_id" : "123",
  #     "access_token" : "12345"
  # }
  def create
    user = User.where(:email_id => params[:email_id]).first
    user = User.new if user.nil?
    params[:user].each { |key, value| user[key] = value }
    result = user.save! if user.valid?
    result ? create_response(200, user) : create_response(400, user.errors)
  end
end
