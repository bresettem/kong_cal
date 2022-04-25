class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :claim, dependent: :destroy
  has_many :tribe_items, dependent: :destroy
  has_many :goals

  after_create_commit :seed_database

  def seed_database
    items = [{
               item: 'Starship',
               daily_yield: '5.2',
               price: 200,
               owned: 0,
               user_id: id
             },
             {
               item: 'City',
               daily_yield: '11',
               price: 400,
               owned: 0,
               user_id: id
             },
             {
               item: 'Arena',
               daily_yield: '24',
               price: 800,
               owned: 0,
               user_id: id
             },
             {
               item: 'Mini Starship',
               daily_yield: '1',
               price: 50,
               owned: 0,
               user_id: id
             },
             {
               item: 'Lab',
               daily_yield: '2.5',
               price: 100,
               owned: 0,
               user_id: id
             },
             {
               item: 'Mini Lab',
               daily_yield: '0.15',
               price: 10,
               owned: 0,
               user_id: id
             },
    ]
    user = User.find(id)
    user.tribe_items.insert_all!(items)
  end
end