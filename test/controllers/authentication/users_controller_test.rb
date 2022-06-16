require "test_helper"

class Authentication::UsersControllerTest < ActionDispatch::IntegrationTest


  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do 
      post users_url, params: { user: { email: 'juan@vendelo.com', username: 'juan09', password: 'testme' } }
      #una vez que se haga la peticion va a comprobar que haya un usuario mas
    end

    assert_redirected_to products_url #para que al crear una cat nos envie al listado
  end

end
