# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :orders, dependent: :destroy
  has_many :time_sheets, dependent: :destroy
  belongs_to :vendor, optional: true
  enum role: { consumer: 1, employee: 90, admin: 99 }
end
