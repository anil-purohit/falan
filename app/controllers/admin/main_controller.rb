class Admin::MainController < ApplicationController
  before_action :validate_admin_password

  private
  def validate_admin_password
    if params[:password] != "obsAdmin"
      redirect_to root_path
    end
  end
end
