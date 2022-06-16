class ApplicationController < ActionController::Base
	include Pagy::Backend #incluye todo el codigo de la gema pagy para que podamos utilizarlo en nuestros controladores
	
	around_action :switch_locale #por cada peticion que venga, se llame a switch_locale
	before_action :set_current_user
	before_action :protect_pages

	def switch_locale(&action)
		I18n.with_locale(locale_from_header, &action) #with_locale cambia el idioma de la aplicacion para esa peticion en concreto, se le pasa el idioma q tiene el usuario en su navegador que es locale_from_header
	end

	private

	def locale_from_header
		#obtiene el idioma del navegador, y el .scan es para obtener solo "es" o "en" en caso de ingles o español
		request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
		#añadir el operador & lo que hace es una condicional como un if comprobando si existe  pero evitandonos tanto codigo, 
		#si la cabecera HTTP_ACCEPT_LANGUAGE existe, ejecuta el scan
	end

	def set_current_user
		#guardamos el usuario en la clase current que es un modelo creado para guardar variables accesibles en la vista, controlador y modelos
		Current.user = User.find_by(id: session[:user_id]) if session[:user_id]#la diferencia con find del find_by es que find si no lo encuentra, nos saltara un error
	end

	def protect_pages
		redirect_to new_session_path, alert: t('common.not_logged_in') unless Current.user #unless es "sino" que redirija al inicio de sesion sino temenos un current.user
	end
end
