require "test_helper"

class Authentication::SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup #corre antes de cualquiera de los otros test
    @user = users(:paco) #obtiene la fixture de paco
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should login an user by email" do
    #login es un campo ficticio para luego poder comparar si se inicia sesion con correo o username
    post sessions_url, params: { login: @user.email, password: 'testme' } #la contraseña del fixture esta encriptada por lo que colocamos aca la contraseña escrita

    assert_redirected_to products_url #para que al crear una cat nos envie al listado
  end

  test "should login an user by username" do
    #login es un campo ficticio para luego poder comparar si se inicia sesion con correo o username
    post sessions_url, params: { login: @user.username, password: 'testme' } #la contraseña del fixture esta encriptada por lo que colocamos aca la contraseña escrita

    assert_redirected_to products_url #para que al crear una cat nos envie al listado
  end



end
