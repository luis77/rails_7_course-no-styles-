require 'test_helper' #incluye en este archivo el codigo que haya en test_helper que incluye elementos de configuracion para todos nuestros tests

class ProductsControllerTest < ActionDispatch::IntegrationTest

	test 'render a list of projects' do
		#prueba en el index de product
		get products_path #para renderizar un listado de productos tenemos que acceder a esa pagina con peticion de tipo GET

		#comprobamos que lo que nos devuelve es lo que estamos esperando
		assert_response :success #esperamos que la respuesta sea satisfactoria
		assert_select '.product', 12 #verificamos que esperamos doce productos
		assert_select '.category', 9 #verificamos que esperamos 9 productos
	end

	test 'render a list of products filtered by category' do
		get products_path(category_id: categories(:computers).id) #para renderizar un listado de productos tenemos que acceder a esa pagina con peticion de tipo GET

		#comprobamos que lo que nos devuelve es lo que estamos esperando
		assert_response :success #esperamos que la respuesta sea satisfactoria
		assert_select '.product', 5 #verificamos que esperamos 5 productos filtrado
	end

	test 'render a list of products filtered by min_price and max_price' do
		get products_path(min_price: 160, max_price: 200) #para renderizar un listado de productos tenemos que acceder a esa pagina con peticion de tipo GET

		#comprobamos que lo que nos devuelve es lo que estamos esperando
		assert_response :success #esperamos que la respuesta sea satisfactoria
		assert_select '.product', 3 #verificamos que esperamos 3 productos filtrado		
		assert_select 'h2', 'Nintendo Switch' 		
	end

	test 'search a product by query_text' do
		get products_path(query_text: 'Switch') #para renderizar un listado de productos tenemos que acceder a esa pagina con peticion de tipo GET

		#comprobamos que lo que nos devuelve es lo que estamos esperando
		assert_response :success #esperamos que la respuesta sea satisfactoria
		assert_select '.product', 1 #verificamos que esperamos 1 producto filtrado		
		assert_select 'h2', 'Nintendo Switch' 		
	end

	#test para ordenamiento de productos
	test 'sort products by expensive prices first' do
		get products_path(order_by: 'expensive') #para renderizar un listado de productos tenemos que acceder a esa pagina con peticion de tipo GET

		#comprobamos que lo que nos devuelve es lo que estamos esperando
		assert_response :success #esperamos que la respuesta sea satisfactoria
		assert_select '.product', 12 #verificamos que esperamos 12 productos filtrado		
		assert_select '.products .product:first-child h2', 'Seat Panda clásico' 		
	end

	#test para ordenamiento de productos
	test 'sort products by cheapest prices first' do
		get products_path(order_by: 'cheapest') #para renderizar un listado de productos tenemos que acceder a esa pagina con peticion de tipo GET

		#comprobamos que lo que nos devuelve es lo que estamos esperando
		assert_response :success #esperamos que la respuesta sea satisfactoria
		assert_select '.product', 12 #verificamos que esperamos 12 productos filtrado		
		assert_select '.products .product:first-child h2', 'El hobbit' #verificamos que el primero sea el hobbit 		
	end
	test 'render a detail product page' do
		#verifica que en la vista del producto se encuentren los elementos con su clase
		get product_path(products(:ps4)) #busca una fixture llamada ps4

		assert_response :success #esperamos que la respuesta sea satisfactoria
		#esperamos que renderize los datos
		assert_select '.title', 'PS4 Fat'
		assert_select '.description', 'PS4 en buen estado'
		assert_select '.price', '150$'

	end

	#test para new
	test 'render a new product form' do
		get new_product_path

		assert_response :success #la respuesta que sea satisfactoria
		assert_select 'form' #esperamos a que tenga un formulario
	end

	test 'allow to create a new product' do 
		#hacemos el test para verificar que se estan guardando los productos correctamente
		#el metodo es post, y que espera ciertos parametros
		post products_path, params: {
			product: {
				title: 'Nintendo 64',
				description: 'le faltan los cables',
				price: 45, 
				category_id: categories(:videogames).id #obtenemos las fixture de categiries, en concreto la videogames
			}
		}

		#si se ha guardado correctamente este producto
		#que se compruebe que se esta haciendo un redirect
		assert_redirected_to products_path

		#comprobamos que lo que contenga el flash[:notice] debe ser igual a su mensaje
		assert_equal flash[:notice], 'Tu producto se ha creado correctamente' 
	end

	test 'does not allow to create a new product with empty fields' do 
		post products_path, params: {
			product: {
				title: '',
				description: 'le faltan los cables',
				price: 45
			}
		}

		assert_response :unprocessable_entity #que la respuesta sea esta, devolviendo un error 422
	end

	#test para edit
	test 'render an edit product form' do
		get edit_product_path(products(:ps4))

		assert_response :success #la respuesta que sea satisfactoria
		assert_select 'form' #esperamos a que tenga un formulario
	end

	#test para actualizar un producto
	test 'allow to update a product' do 
		#hacemos el test para verificar que se estan guardando los productos correctamente
		#el metodo es patch, y que espera ciertos parametros
		patch product_path(products(:ps4)), params: {
			product: {
				price: 165
			}
		}

		#si se ha guardado correctamente este producto
		#que se compruebe que se esta haciendo un redirect
		assert_redirected_to products_path

		#comprobamos que lo que contenga el flash[:notice] debe ser igual a su mensaje
		assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente' 
	end


	#test para que al actualizar un producto y sea nulo se espere unprocessable_entity
	test 'does not allow to update a product with an invalid field' do 
		#hacemos el test para verificar que se estan guardando los productos correctamente
		#el metodo es patch, y que espera ciertos parametros
		patch product_path(products(:ps4)), params: {
			product: {
				price: nil
			}
		}

		assert_response :unprocessable_entity
	end


	#test para eliminar productos
	test 'can delete products' do

		#el munero total de productos debe ser menor que uno o sea que se reste el producto que se va a eliminar
		#para ello debemos saber cuantos productos habia antes de hacer la peticion
		assert_difference('Product.count', -1) do # esperamos que el total despues de la peticion se reste 1
			delete product_path(products(:ps4)) #peticion para eliminar el producto
		end


		#si se ha eliminado correctamente este producto
		#que se compruebe que se esta haciendo un redirect
		assert_redirected_to products_path

		#comprobamos que lo que contenga el flash[:notice] debe ser igual a su mensaje
		assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente' 

	end


end