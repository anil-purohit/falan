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
        user[:location] = params[:location]
        user[:lat] = lat_long.split(",")[0]
        user[:long] = lat_long.split(",")[1]
      end
    end
    add_location_info_to_user user, get_default_location if user[:location].blank?
    result = user.save! if user.valid?
    result ? create_response(200, user) : create_response(400, user.errors)
  end

  def update_user_location
    id = params[:id].to_i
    return create_response(400, "Invalid User Id.") if id <=0
    is_location_present = params[:location].present?
    is_location_present ||= (params[:lat].present? && params[:long].present?)
    return create_response(400, "Invalid Location Data") unless is_location_present
    user = User.where(:id => id).first
    location_info = {}
    if params[:location].present?
      lat_long_info = Geokit::Geocoders::GoogleGeocoder.geocode params[:location].to_s
      if lat_long_info.present?
        lat_long = lat_long_info.ll
        location_info[:location] = params[:location]
        location_info[:lat] = lat_long.split(",")[0]
        location_info[:long] = lat_long.split(",")[1]
      end
    else
      city_info = Geokit::Geocoders::GoogleGeocoder.do_reverse_geocode ("#{params[:lat]},#{params[:long]}")
      location_info[:location] = city_info.city
      location_info[:lat] = params[:lat]
      location_info[:long] = params[:long]
    end
    location_info = get_default_location if location_info.blank? || location_info[:location].blank?

    add_location_info_to_user(user, location_info)
    result = user.save! if user.valid?
    result ? create_response(200, user) : create_response(400, user.errors)
  end

  def add_location_info_to_user(user, location_info)
    user[:location] = location_info[:location]
    user[:lat] = location_info[:lat]
    user[:long] = location_info[:long]
  end

  def get_default_location
    location_info = {}
    location_info[:location] = "Delhi"
    location_info[:lat] = 0.0
    location_info[:long] = 0.0
    location_info
  end
end
