class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:index, :notify]

  def index
  end

  def notify
    @success_result = {:result => "Thanks for showing interest in us.", :status => :success}
    @error_result = {:error => "Oops!!! Something went wrong.", :status => :internal_server_error}
    if request.xhr?
      new_user = NotifyUser.where(:email_id => params[:email]).first
      return render :json => @success_result if new_user.nil?
      new_user = NotifyUser.new(:email_id => params[:email])
      result = new_user.save!
      return render :json => result ? @success_result : @error_result
    end
  end
end
