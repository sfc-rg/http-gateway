class InitialSchema < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.string :icon_url

      t.timestamps null: false
    end

    create_table :slack_credentials do |t|
      t.references :users, index: true
      t.string :user_id

      t.timestamps null: false
    end

    create_table :proxy_rules do |t|
      t.references :user, index: true
      t.string :domain
      t.string :name
      t.string :url
      t.integer :auth_type

      t.timestamps null: false
      t.datetime :expired_at, index: true
    end
  end
end
