class Authentication::UsersController < ApplicationController
	skip_before_action :protect_pages #para evitar redireccionamiento infinito

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			session[:user_id] = @user.id #para que automaticamente el usuario pueda acceder a la aplicacion sin loguearse de nuevo
			redirect_to products_path, notice: t('.created')
		else
			render :new, status: :unprocessable_entity
		end
	end

	private

	def user_params
		params.require(:user).permit(:email, :username, :password)
	end

end