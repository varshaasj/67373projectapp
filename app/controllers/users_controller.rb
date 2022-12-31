class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource

    def index
        # finding all the active users and paginating that list (will_paginate)
        @users = User.all.paginate(page: params[:page]).per_page(15)
    end

    def new
        @user = User.new
    end

    def edit
        @user.role = "nurse" if current_user.role?(:nurse)
    end

    def create
        @user = User.new(user_params)
        @user.role = "nurse" if current_user.role?(:nurse)
        if  @user.save
            flash[:notice] = "Successfully added #{@user.proper_name} as a user."
            #session[:user_id] = @user.id
            redirect_to @users
        else
            render action: 'new'
        end
    end

    def update
        if  @user.update_attributes(user_params)
            flash[:notice] = "Successfully updated #{@user.proper_name}."
            redirect_to users_url
        else
            render action: 'edit'
        end
    end

    private
        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params.require(:user).permit(:first_name, :last_name, :active, :username, :role, :password, :password_confirmation)
        end
end
