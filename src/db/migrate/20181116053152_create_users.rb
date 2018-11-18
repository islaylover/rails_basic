class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false #not null追加
      t.string :email, null: false #not null追加
      t.string :password_digest, null: false #not null追加

      t.timestamps
      t.index :email, unique: true #ユニークインデックス追加
    end
  end
end
