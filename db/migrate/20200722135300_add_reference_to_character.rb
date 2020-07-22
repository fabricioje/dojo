class AddReferenceToCharacter < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :reference, :integer
  end
end
