class Current < ActiveSupport::CurrentAttributes
	attribute :user #declaramos que valores vamos a guardar, en las vistas podemos acceder a su valor con <%= Current.user%> o <%= Current.user.inspect%> que tendriamos algo mas detallado
end