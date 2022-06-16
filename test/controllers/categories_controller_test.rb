require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  
  #este metodo se ejecuta entes de los tests
  #se correo lo que hay dentro antes de los test, es para preparar los test y comparar fixtures
  setup do
    login #metodo creado en el archivo test_herlper. inicia sesion para que no de error los test donde se crean registros por el usuario
    @category = categories(:clothes)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: @category.name } }
    end

    assert_redirected_to categories_url #para que al crear una cat nos envie al listado
  end


  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: { category: { name: @category.name } }
    assert_redirected_to categories_url #para que al crear una cat nos envie al listado
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end

    assert_redirected_to categories_url
  end
end
