class UsersController < ApplicationController
  ssl_required :show, :new, :edit, :create, :update
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  filter_access_to :all
  filter_access_to :show, :edit, :update, :attribute_check => true, :load_method => :current_user

  # GET /users/1
  # GET /account
  def show
    @user = @current_user
  end

  # GET /users/new
  # GET /signup
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # GET /account/edit
  def edit
    @user = @current_user
  end

  # POST /users
  # POST /account
  def create
    @user = User.new

    if @user.signup!(params[:user])
      @user.deliver_activation_instructions!
      flash[:success] = t('users.flashs.success.create')
      redirect_to root_url
    else
      render :action => :new
    end
  end

  # PUT /users/1
  # PUT /account
  def update
    @user = @current_user
    @user.attributes = params[:user]

    @user.save do |result|
      if result
        flash[:success] = t('users.flashs.success.update')
        redirect_to account_url
      else
        render :action => :edit
      end
    end
  end
end
