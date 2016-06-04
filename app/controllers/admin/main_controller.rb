class Admin::MainController < ApplicationController
  before_action :validate_admin_password

  private
  def validate_admin_password
  end
end
