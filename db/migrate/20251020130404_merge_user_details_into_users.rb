class MergeUserDetailsIntoUsers < ActiveRecord::Migration[8.0]
  def up
    # Thêm các cột từ user_details vào users
    add_column :users, :full_name, :string
    add_column :users, :phone, :string
    add_column :users, :address, :text
    add_column :users, :date_of_birth, :date
    add_column :users, :gender, :string
    add_column :users, :profile_picture_url, :string

    # Migrate dữ liệu từ user_details sang users
    UserDetail.find_each do |detail|
      User.find(detail.user_id).update_columns(
        full_name: detail.full_name,
        phone: detail.phone,
        address: detail.address,
        date_of_birth: detail.date_of_birth,
        gender: detail.gender,
        profile_picture_url: detail.profile_picture_url
      )
    end

    # Xóa bảng user_details
    drop_table :user_details
  end

  def down
    # Tạo lại bảng user_details
    create_table :user_details do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :phone, null: false
      t.text :address
      t.date :date_of_birth
      t.string :gender, null: false
      t.string :profile_picture_url
      t.timestamps
    end

    # Migrate dữ liệu ngược lại
    User.where.not(full_name: nil).find_each do |user|
      UserDetail.create!(
        user_id: user.id,
        full_name: user.full_name,
        phone: user.phone,
        address: user.address,
        date_of_birth: user.date_of_birth,
        gender: user.gender,
        profile_picture_url: user.profile_picture_url
      )
    end

    # Xóa các cột khỏi users
    remove_column :users, :full_name
    remove_column :users, :phone
    remove_column :users, :address
    remove_column :users, :date_of_birth
    remove_column :users, :gender
    remove_column :users, :profile_picture_url
  end
end
