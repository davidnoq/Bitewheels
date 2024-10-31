class CreateCreditPackages < ActiveRecord::Migration[7.2]
  def change
    create_table :credit_packages do |t|
      t.string :name
      t.integer :credits
      t.integer :price_cents

      t.timestamps
    end
  end
end
