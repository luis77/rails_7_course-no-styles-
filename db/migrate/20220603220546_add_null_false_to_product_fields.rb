class AddNullFalseToProductFields < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :title, false #decimos que null es false, o sea no permitimos valores vacios
    change_column_null :products, :description, false #decimos que null es false, o sea no permitimos valores vacios
    change_column_null :products, :price, false #decimos que null es false, o sea no permitimos valores vacios
  end
end
