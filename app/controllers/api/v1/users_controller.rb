class Api::V1::UsersController < Api::MainController

  def show
    id = params[:id].to_i
    create_response(400, "Invalid User Id.") if id <=0

    user = User.where(:id => params[:id]).first
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
    if params[:location].present?
      location_info = Geokit::Geocoders::GoogleGeocoder.geocode params[:location].to_s
      if location_info.present?
        lat_long = location_info.ll
        user[:lat] = lat_long.split(",")[0]
        user[:long] = lat_long.split(",")[1]
      else
        add_default_location user
      end
    else
      add_default_location user
    end
    result = user.save! if user.valid?
    result ? create_response(200, user) : create_response(400, user.errors)
  end

  def update_user_location
    id = params[:id].to_i
    return create_response(400, "Invalid User Id.") if id <=0 || params[:location].blank?
    user = User.where(:id => id).first
    location_info = Geokit::Geocoders::GoogleGeocoder.geocode params[:location].to_s
    if location_info.present?
      lat_long = location_info.ll
      user[:lat] = lat_long.split(",")[0]
      user[:long] = lat_long.split(",")[1]
    else
      add_default_location user
    end
    result = user.save!
    result ? create_response(200, user) : create_response(400, user.errors)
  end

  def add_default_location(user)
    user[:location] = "Delhi"
    user[:lat] = 28.6139
    user[:long] = 77.2090
  end
end
