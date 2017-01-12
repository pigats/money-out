# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([{
  email: 'andreapigato@gmail.com',
  password: '123456'
},{
  email: 'user-manager@email.com',
  password: '123456',
  role: 1
},{
  email: 'admin@email.com',
  password: '123456',
  role: 2
}])

expenses = Expense.create([{
  user: users.first,
  date: Time.now,
  description: 'ice cream',
  amount: 10.58,
  comment: 'should I expense ice cream?'
}])
