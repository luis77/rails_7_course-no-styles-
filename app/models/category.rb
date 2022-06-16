class Category < ApplicationRecord
	validates :name, presence:true
	
	has_many :products, dependent: :restrict_with_exception #si borramos una categoria, que se lance una excepcion si existe algun producto

end
