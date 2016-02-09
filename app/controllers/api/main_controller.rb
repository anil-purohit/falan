class Api::MainController < ApplicationController
  respond_to :json
  protect_from_forgery :with => :null_session

  def create_response(status, data)
    response = {}
    response[:status] = status
    if status == 200
      response[:data] = data
    else
      response[:error] = data
    end
    render :status => status, :json => response.to_json
  end
end