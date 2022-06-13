class ProductsController < ApplicationController

	def index
		@categories = Category.order(name: :asc).load_async #load_async hace que las consultas se carguen en paralelo optimizando tiempo de carga
		@products = Product.with_attached_photo

		if params[:category_id]
			pp params[:category_id]#imprime en consola el valor del parametro
			@products = @products.where(category_id: params[:category_id])
		end

		if params[:min_price].present?
			@products = @products.where("price >= ?", params[:min_price])
		end

		if params[:max_price].present?
			@products = @products.where("price <= ?", params[:max_price])
		end

		if params[:query_text].present?
			@products = @products.search_full_text(params[:query_text])
		end

		#order_by = {
		#	newest: "created_at DESC",
		#	expensive: "price DESC",
		#	cheapest: "price ASC"
		#}.fetch(params[:order_by]&.to_sym, "created_at DESC")
		#podríamos obtener los valores con order_by[params[:order_by]] pero con .fetch haríamos lo mismo y fetch nos permite usar un valor por defecto que en este caso sería created_at
		#to_sym para convertir a simbolo el parametro que estamos pasando que seria newest, expensivem cheapest.
		#&. es por si el parametro viene vacio, si el parametro existe aplicamos el metodo .to_sym

		#refactorizamos este codigo
		order_by = Product::ORDER_BY.fetch(params[:order_by]&.to_sym, Product::ORDER_BY[:newest])
		#Product::ORDER_BY obtiene la constande declarada en el modelo

		@products = @products.order(order_by).load_async #optimiza la obtencion de registros con foto para solo hacer dos consultas con el active storage
		#en una consulta solo podemos tener una llamada al metodo order y el order siempre va al final
		#el metodo load_async debe ir al final del todo

		@pagy, @products = pagy_countless(@products, items: 12) #hacemos uso de la gema pagy para paginacion y countless porque sera una paginacion infinita y evita hacer el query del count
	end

	def show
		product
	end

	def new
		@product = Product.new #crea una instancia de tipo producto, con todos los registros vacios
	end

	def create
		@product = Product.new(product_params)

		pp @product #muestra por pantalla el contenido de una variable(en el terminal)

		if @product.save
			redirect_to products_path, notice: t('.created')			
		else
			#para que se renderize el form de nuevo y pueda mostrar los errores de la validacion hace que se devuelva al navegador un codigo 422 que es cuando no se ha podido guardar normalmente en vez del 200
			render :new, status: :unprocessable_entity  
		end
	end

	def edit
		product
	end

	def update
		if product.update(product_params) #accede al metodo product devolviendo el producto
			redirect_to products_path, notice: t('.updated')
		else
			render :edit, status: :unprocessable_entity #renderiza de nuevo el form en caso de que el codigo resultante sea 422
		end
	end

	def destroy
		product.destroy #accede al metodo product devolviendo el producto

		redirect_to products_path, notice: t('.destroyed') , status: :see_other
	end

	private

	def product_params
		params.require(:product).permit(:title, :description, :price, :photo, :category_id)
	end

	def product
		@product = Product.find(params[:id])
		
	end
end