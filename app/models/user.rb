# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :orders, dependent: :destroy
  has_many :time_sheets, dependent: :destroy
  has_many :vouchers, foreign_key: :issuer_id, dependent: :destroy
  belongs_to :vendor, optional: true
  
  enum role: { consumer: 1, employee: 90, admin: 99, vendor: 100, system_user: 999 }
end
