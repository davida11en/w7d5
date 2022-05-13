class SessionsController < ApplicationController
    before_action :require_logged_in only:[:create, :destroy, :new]

    def new 
        render :new 
    end 

    def create 
        user = User.find_by_credentials(
            params[:user][:username],
            params[:user][:password]
            )

        if user
            login!(user)
        else
            flash.now[:errors] = ['Invalid username or password']
            render :new
        end
    end

    def destroy 
        logout!
        redirect_to new_session_url
    end
end
