# MoneyOut 💸

expenses tracking for humans 👫 and machines 🤖

## Components

- 🤖 Rails powered json/jsonapi RESTful API, with jwt authentication
  - http://rubyonrails.org/
  - http://jsonapi.org/
  - https://jwt.io/
- 👫 Ember.js powered client
  - http://emberjs.com

## Dependencies

- ruby (developed on v2.3)
- node (developed on v7.3)

## Install

- `$ gem install bundler && bundle install`
- `$ rake ember:install`

## Run locally

- `$ rails s`
- go to http://localhost:3000

## API spec

- `$ rspec spec/requests`

## Demo instance

A demo instance is available at: https://moneyout.herokuapp.com

Feel free to sign up as a user, and/or access with:

- user-manager@email.com:123456 (role: user manager)
- admin@email.com:123456 (role: admin)