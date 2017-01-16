require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  before :all do
    @user = User.create(email: 'test@test.com', password: 'test-test')
  end

  after :all do
    User.all.each do |user|
      user.destroy
    end
  end

  after :each do
    Expense.all.each do |expense|
      expense.destroy
    end
  end

  context 'Unauthenticated' do
    describe 'Collection' do
      describe 'GET /api/expenses' do
        it 'is unauthorized' do
          get expenses_path
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'GET /api/users/:id/expenses' do
        it 'is unauthorized' do
          get user_expenses_path(@user)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'POST /api/users/:id/expenses' do
        it 'is unauthorized' do
          post user_expenses_path(@user)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'Resource' do
      before :each do
        @expense = Expense.create(user: @user, description: 'some expense', amount: 10.50, date: DateTime.now)
      end

      describe 'GET /api/expenses/:id' do
        it 'is unauthorized' do
          get expense_path(@expense)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'DELETE /api/expenses/:id' do
        it 'is unauthorized' do
          delete expense_path(@expense)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'PATCH /api/expenses/:id' do
        it 'is unauthorized' do
          patch expense_path(@expense)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  context 'Authenticated as user' do
    before :all do
      @user_headers = headers.merge('AUTHORIZATION' => "bearer #{token_for @user}")
    end

    describe 'Collection' do
      describe 'GET /api/expenses' do
        it 'is forbidden' do
          get expenses_path, headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'GET /api/users/:id/expenses' do
        it 'list my expenses' do
          get user_expenses_path(@user), headers: @user_headers
          expect(response).to have_http_status(:success)
          expenses = JSON.parse(response.body)
          expect(expenses['data'].length).to be @user.expenses.count
        end

        it 'can not list others\' expenses' do
          get expenses_path(@user.id + 1), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end

        describe 'filter' do
          describe 'by description' do
            it 'returns matching expenses' do
              keyword = 'keyword'
              @another_expense = Expense.create(user: @user, description: keyword, amount: 10.50, date: DateTime.now)
              get user_expenses_path(@user, description: keyword), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be 1
              expect(expenses['data'][0]['id'].to_i).to be @another_expense.id
            end
          end

          describe 'by date' do
            it 'returns expenses in date range' do
              date = 1.year.ago
              @another_expense = Expense.create(user: @user, description: 'some other expense', amount: 10.50, date: date)
              get user_expenses_path(@user, date: { from: date - 1.day, to: date + 1.day }), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be 1
              expect(expenses['data'][0]['id'].to_i).to be @another_expense.id
            end

            it 'does not apply an invalid date range' do
              date = DateTime.now
              @another_expense = Expense.create(user: @user, description: 'some other expense', amount: 10.50, date: date)
              get user_expenses_path(@user, date: { from: date + 1.day, to: date - 1.day }), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be Expense.where(user_id: @user.id).count
            end

            it 'does not apply an incomplete date range' do
              date = DateTime.now
              @another_expense = Expense.create(user: @user, description: 'some other expense', amount: 10.50, date: date)
              get user_expenses_path(@user, date: { from: date + 1.day }), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be Expense.where(user_id: @user.id).count
            end
          end

          describe 'by amount' do
            it 'returns expenses in amount range' do
              amount = 100_000
              @another_expense = Expense.create(user: @user, description: 'some other expense', amount: amount, date: DateTime.now)
              get user_expenses_path(@user, amount: { from: amount - 1, to: amount + 1 }), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be 1
              expect(expenses['data'][0]['id'].to_i).to be @another_expense.id
            end

            it 'does not apply an invalid amount range' do
              @another_expense = Expense.create(user: @user, description: 'some other expense', amount: 10.50, date: DateTime.now)
              get user_expenses_path(@user, amount: { from: 1, to: 0 }), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be Expense.where(user_id: @user.id).count
            end

            it 'does not apply an incomplete amount range' do
              @another_expense = Expense.create(user: @user, description: 'some other expense', amount: 10.50, date: DateTime.now)
              get user_expenses_path(@user, amount: { to: 0 }), headers: @user_headers
              expect(response).to have_http_status(:success)
              expenses = JSON.parse(response.body)
              expect(expenses['data'].length).to be Expense.where(user_id: @user.id).count
            end
          end
        end
      end

      describe 'POST /api/users/:id/expenses' do
        it 'creates my expense' do
          n_expenses = Expense.where(user_id: @user.id).count
          post user_expenses_path(@user), params: payload_for(:create_expense), headers: @user_headers
          expect(response).to have_http_status(:created)
          expect(Expense.where(user_id: @user.id).count).to be n_expenses + 1
        end

        it 'can not create others\' expenses' do
          post user_expenses_path(@user.id + 1), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'Resource' do
      before :each do
        @another_user = User.create(email: 'another-user-test@test.com', password: 'test-test')
        @expense = Expense.create(user: @user, description: 'some expense', amount: 10.50, date: DateTime.now)
        @another_expense = Expense.create(user: @another_user, description: 'some other expense', amount: 50.10, date: DateTime.now)
      end

      describe 'GET /api/expenses/:id' do
        it 'shows my expense' do
          get expense_path(@expense), headers: @user_headers
          expect(response).to have_http_status(:success)
          expense = JSON.parse(response.body)
          expect(expense['data']['type']).to match 'expense'
          expect(expense['data']['id'].to_i).to be @expense.id
        end

        it 'can not show others\' expenses' do
          get expense_path(@another_expense), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'DELETE /api/expenses/:id' do
        it 'deletes my expense' do
          delete expense_path(@expense), headers: @user_headers
          expect(response).to have_http_status(:no_content)
          expect(Expense.exists?(@expense.id)).to be false
        end

        it 'can not delete others\' expenses' do
          delete expense_path(@another_expense), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'PATCH /api/expenses/:id' do
        it 'updates my expense' do
          description = 'new description'
          amount = 42.0
          date = DateTime.now
          comment = 'new comment'
          patch expense_path(@expense), params: payload_for(:update_expense, {
            description: description,
            amount: amount,
            date: date,
            comment: comment
          }), headers: @user_headers 

          expect(response).to have_http_status(:success)
          expect(@expense.reload.description).to match description
          expect(@expense.amount).to be amount
          expect((@expense.date - date).to_i).to be 0
          expect(@expense.comment).to match comment
        end

        it 'can not update others\' expenses' do
          patch expense_path(@another_expense), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  context 'Authenticated as admin' do
    before :all do
      @admin = User.create(email: 'test-admin@test.com', password: 'test-test', role: 2)
      @admin_headers = headers.merge('AUTHORIZATION' => "bearer #{token_for @admin}")
      @another_user = User.create(email: 'another-user-test@test.com', password: 'test-test')
      @another_expense = Expense.create(user: @another_user, description: 'some other expense', amount: 50.10, date: DateTime.now)
    end

    before :each do
      @expense = Expense.create(user: @user, description: 'some expense', amount: 10.50, date: DateTime.now)
    end

    describe 'Collection' do
      describe 'GET /api/expenses' do
        it 'lists all expenses' do
          get expenses_path, headers: @admin_headers
          expect(response).to have_http_status(:success)
          expenses = JSON.parse(response.body)
          expect(expenses['data'].length).to be Expense.count
        end
      end

      describe 'GET /api/users/:id/expenses' do
        it 'list anyone\'s expenses' do
          get user_expenses_path(@user), headers: @admin_headers
          expect(response).to have_http_status(:success)
          expenses = JSON.parse(response.body)
          expect(expenses['data'].length).to be @user.expenses.count
        end
      end

      describe 'POST /api/users/:id/expenses' do
        it 'creates anyone\'s expense' do
          n_expenses = Expense.where(user_id: @user.id).count
          post user_expenses_path(@user), params: payload_for(:create_expense), headers: @admin_headers
          expect(response).to have_http_status(:created)
          expect(Expense.where(user_id: @user.id).count).to be n_expenses + 1
        end
      end
    end

    describe 'Resource' do
      describe 'GET /api/expenses/:id' do
        it 'shows anyone\'s expense' do
          get expense_path(@expense), headers: @admin_headers
          expect(response).to have_http_status(:success)
          expense = JSON.parse(response.body)
          expect(expense['data']['type']).to match 'expense'
          expect(expense['data']['id'].to_i).to be @expense.id
        end
      end

      describe 'DELETE /api/expenses/:id' do
        it 'deletes anyone\'s expense' do
          delete expense_path(@expense), headers: @admin_headers
          expect(response).to have_http_status(:no_content)
          expect(Expense.exists?(@expense.id)).to be false
        end
      end

      describe 'PATCH /api/expenses/:id' do
        it 'updates anyone\'s expense' do
          description = 'new description'
          amount = 42.0
          date = DateTime.now
          comment = 'new comment'
          patch expense_path(@expense), params: payload_for(:update_expense, {
            description: description,
            amount: amount,
            date: date,
            comment: comment
          }), headers: @admin_headers 

          expect(response).to have_http_status(:success)
          expect(@expense.reload.description).to match description
          expect(@expense.amount).to be amount
          expect((@expense.date - date).to_i).to be 0
          expect(@expense.comment).to match comment
        end
      end
    end
  end
end
