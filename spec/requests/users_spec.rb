require 'rails_helper'

RSpec.describe "Users", type: :request do
  after :each do
    User.all.each do |user|
      user.destroy
    end
  end

  context 'Unauthenticated' do
    describe 'Collection' do
      describe 'GET /api/users' do
        it 'is unauthorized' do
          get users_path
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'POST /api/users' do
        it 'requires a user' do
          post users_path 
          expect(response).to have_http_status(:unprocessable_entity)
        end
        it 'creates a user' do
          n_user = User.count
          post users_path, params: payload_for(:create_user), headers: headers
          expect(response).to have_http_status(:created)
          expect(User.count).to equal n_user + 1
        end
      end
    end

    describe 'Resource' do
      before :each do
        @user = User.create(email: 'test@test.com', password: 'test-test')
      end

      describe 'GET /api/users/me' do
        it 'is unauthorized' do
          get users_me_path
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'DELETE /api/users/:id' do
        it 'is unauthorized' do
          delete user_path(@user)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'PATCH /api/users/:id' do
        it 'is unauthorized' do
          patch user_path(@user)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'Email confirm' do
        describe 'PATCH /api/users/:id/email-confirm' do
          it 'is unauthorized' do
            patch user_email_confirm_path(@user)
            expect(response).to have_http_status(:unauthorized)
          end
        end 
      end

      describe 'Password reset' do
        describe 'POST /api/users/password-reset' do
          it 'generates a password reset token' do
            expect(@user.password_reset_token).to be_nil
            post users_password_reset_path, params: payload_for(:password_reset_request), headers: headers
            expect(@user.reload.password_reset_token).not_to be_nil
          end
        end

        describe 'PATCH /api/users/password-reset' do
          it 'reset a password' do
            password_reset_token = 'password_reset_token'
            password = 'new-test-password'
            @user.update(password_reset_token: password_reset_token)

            patch users_password_reset_path, params: payload_for(:password_reset, {
              'password-reset-token': @user.password_reset_token,
              'password': password
            }), headers: headers

            expect(@user.reload.authenticate(password)).not_to be false
          end
        end
      end
    end
  end 

  context 'Authenticated as user' do
    before :each do
      @user = User.create(email: 'test@test.com', password: 'test-test')
      @user_headers = headers.merge('AUTHORIZATION' => "bearer #{token_for @user}")
    end

    describe 'Collection' do
      describe 'GET /api/users' do
        it 'is forbidden' do
          get users_path, headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'Resource' do
      describe 'GET /api/users/me' do
        it 'returns me' do
          get users_me_path, headers: @user_headers
          expect(response).to have_http_status(:success)
          me = JSON.parse(response.body)
          expect(me['data']['type']).to match 'user'
          expect(me['data']['id'].to_i).to equal @user.id
        end
      end

      describe 'GET /api/users/:id' do
        it 'shows me' do
          get user_path(@user), headers: @user_headers
          expect(response).to have_http_status(:success)
          me = JSON.parse(response.body)
          expect(me['data']['type']).to match 'user'
          expect(me['data']['id'].to_i).to equal @user.id
        end

        it 'can not show others' do
          get user_path(@user.id + 1), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'DELETE /api/users/:id' do
        it 'deletes me' do
          n_user = User.count
          delete user_path(@user), headers: @user_headers
          expect(response).to have_http_status(:no_content)
          expect(User.count).to be n_user - 1
        end

        it 'can not delete others' do
          delete user_path(@user.id + 1), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'PATCH /api/users/:id' do
        it 'updates me' do
          email = 'another-test@test.com'
          password = 'another-test-password'

          patch user_path(@user), params: payload_for(:update_user, {
            email: email,
            password: password
          }), headers: @user_headers

          expect(response).to have_http_status(:success)
          expect(@user.reload.email).to match email
          expect(@user.authenticate(password)).not_to be false
        end

        it 'can not update others' do
          patch user_path(@user.id + 1), headers: @user_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'Email confirm' do
        describe 'PATCH /api/users/:id/email-confirm' do
          it 'confirms me' do
            expect(@user.email_confirm_token).not_to be_nil

            patch user_email_confirm_path(@user), params: payload_for(:confirm_user, {
              'email-confirm-token' => @user.email_confirm_token
            }), headers: @user_headers

            expect(response).to have_http_status(:success)
            expect(@user.reload.email_confirm_token).to be_nil
          end

          it 'can not confirm others' do
            patch user_email_confirm_path(@user.id + 1), headers: @user_headers

            expect(response).to have_http_status(:forbidden)
          end
        end 
      end
    end
  end

  context 'Authenticated as user manager' do
    before :each do
      @user = User.create(email: 'test@test.com', password: 'test-test')
      @user_manager = User.create(email: 'test-user-manager@test.com', password: 'test-test', role: 1)
      @another_user_manager = User.create(email: 'test-another-user-manager@test.com', password: 'test-test', role: 1)
      @admin = User.create(email: 'test-admin@test.com', password: 'test-test', role: 2)
      @user_manager_headers = headers.merge('AUTHORIZATION' => "bearer #{token_for @user_manager}")
    end

    describe 'Collection' do
      describe 'GET /api/users' do
        it 'lists all users' do
          get users_path, headers: @user_manager_headers
          expect(response).to have_http_status(:success)
          users = JSON.parse(response.body)
          expect(users['data'].length).to be User.count
        end
      end
    end

    describe 'Resource' do
      describe 'GET /api/users/:id' do
        it 'shows anyone' do
          get user_path(@admin), headers: @user_manager_headers
          expect(response).to have_http_status(:success)
          user = JSON.parse(response.body)
          expect(user['data']['type']).to match 'user'
          expect(user['data']['id'].to_i).to equal @admin.id
        end
      end

      describe 'DELETE /api/users/:id' do
        it 'deletes a user' do
          delete user_path(@user), headers: @user_manager_headers
          expect(response).to have_http_status(:no_content)
          expect(User.exists?(@user.id)).to be false
        end

        it 'deletes a user manager' do
          delete user_path(@another_user_manager), headers: @user_manager_headers
          expect(response).to have_http_status(:no_content)
          expect(User.exists?(@another_user_manager.id)).to be false
        end

        it 'can not delete admins' do
          delete user_path(@admin), headers: @user_manager_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'PATCH /api/users/:id' do
        it 'can not update users\' email and password' do
          email = 'another-test@test.com'
          password = 'another-test-password'

          patch user_path(@user), params: payload_for(:update_user, {
            email: email,
            password: password
          }), headers: @user_manager_headers

          expect(response).to have_http_status(:success)
          expect(@user.reload.email).not_to match email
          expect(@user.authenticate(password)).to be false
        end

        it 'updates a user\'s role' do
          role = 1

          patch user_path(@user), params: payload_for(:update_user, {
            role: role
          }), headers: @user_manager_headers

          expect(response).to have_http_status(:success)
          expect(@user.reload.role).to equal role
        end

        it 'updates a user manager\'s role' do
          role = 0

          patch user_path(@another_user_manager), params: payload_for(:update_user, {
            role: role
          }), headers: @user_manager_headers

          expect(response).to have_http_status(:success)
          expect(@another_user_manager.reload.role).to equal role
        end

        it 'can not update admins\' roles' do
          patch user_path(@admin), headers: @user_manager_headers
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'Email confirm' do
        describe 'PATCH /api/users/:id/email-confirm' do
          it 'confirms anyone' do
            expect(@admin.email_confirm_token).not_to be_nil

            patch user_email_confirm_path(@admin), params: payload_for(:confirm_user, {
              'email-confirm-token' => @admin.email_confirm_token
            }), headers: @user_manager_headers

            expect(response).to have_http_status(:success)
            expect(@admin.reload.email_confirm_token).to be_nil
          end
        end 
      end
    end
  end

  context 'Authenticated as admin' do
    before :each do
      @user = User.create(email: 'test@test.com', password: 'test-test')
      @user_manager = User.create(email: 'test-user-manager@test.com', password: 'test-test', role: 1)
      @admin = User.create(email: 'test-admin@test.com', password: 'test-test', role: 2)
      @another_admin = User.create(email: 'test-another-admin@test.com', password: 'test-test', role: 2)
      @admin_headers = headers.merge('AUTHORIZATION' => "bearer #{token_for @admin}")
    end

    describe 'Resource' do
      describe 'DELETE /api/users/:id' do
        it 'deletes anyone' do
          delete user_path(@another_admin), headers: @admin_headers
          expect(response).to have_http_status(:no_content)
          expect(User.exists?(@another_admin.id)).to be false
        end
      end

      describe 'PATCH /api/users/:id' do
        it 'updates anyone\'s role' do
          role = 0

          patch user_path(@another_admin), params: payload_for(:update_user, {
            role: role
          }), headers: @admin_headers

          expect(response).to have_http_status(:success)
          expect(@another_admin.reload.role).to equal role
        end
      end
    end
  end
end
