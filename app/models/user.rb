class User < ApplicationRecord
	has_secure_password #añade todos los metodos para guardar la contraseña encriptada

	validates :email, presence: true, uniqueness: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: :invalid
    }
	validates :username, presence: true, uniqueness: true, length: { in: 3..15 },
	format: {
		with: /\A[a-z-0-9-A-Z]+\z/,
		message: :invalid
	}#para que en username no se guarden caracteres especiales o espacios

	validates :password, length: { minimum: 6 }

	before_save :downcase_attributes

	private
	#para que no exista usuarios diferentes con el mismo username con mayusculas y minusculas
	def downcase_attributes
		self.username = username.downcase #para que guarde el username en minisculas
		self.email = email.downcase #para que guarde el username en minisculas
	end
end
