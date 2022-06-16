class Authentication::SessionsController < ApplicationController
	skip_before_action :protect_pages #para evitar redireccionamiento infinito
	
	def new
	end

	def create
		@user = User.find_by("email = :login OR username = :login", {login: params[:login]})
		pp @user #muestra el valor de la variable en la consola

		#comprueba que la contraseña sea valida
		if @user&.authenticate(params[:password])#& realiza authenticate si el usuario existe
			#el metodo authenticate viene del modelo user debido a que usamos has_secure_password que hereda toda la logica, entre ello authenticate
			session[:user_id] = @user.id #para que automaticamente el usuario pueda acceder a la aplicacion sin loguearse de nuevo
			redirect_to products_path, notice: t('.created')
		else
			redirect_to new_session_path, alert: t('.failed')
		end
	end


end