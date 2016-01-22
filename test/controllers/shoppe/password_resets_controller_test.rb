require 'test_helper'

module Shoppe
  class PasswordResetsControllerTest
    class GetNewTest < ControllerTestCase
      test "should render 200 response when GETing new action" do
        get :new, use_route: :shoppe
        assert_response :success
      end
    end

    class PostCreateTest < ControllerTestCase
      # Email not found
      test 'should redirect to the login page with email prefilled when email_address not found' do
        post :create, email_address: 'unknown@email.com', use_route: :shoppe
        assert_redirected_to login_path(email_address: 'unknown@email.com')
      end

      test 'should not send an email when email_address not found' do
        post :create, email_address: 'unknown@email.com', use_route: :shoppe
        assert_nil ActionMailer::Base.deliveries.last
      end

      test 'should set notice even when email_address not found, so that the user doesnt know if the email address exisits in the db' do
        post :create, email_address: 'unknown@email.com', use_route: :shoppe
        assert_not_nil flash[:notice]
      end

      # Email found
      test 'should redirect to the login page with email prefilled when email_address is found' do
        user = create(:user)
        post :create, email_address: user.email_address, use_route: :shoppe
        assert_redirected_to login_path(email_address: user.email_address)
      end

      test 'should reset the user password when email_address is found' do
        user = create(:user)
        old_password = user.password_digest
        post :create, email_address: user.email_address, use_route: :shoppe
        assert_not_equal old_password, user.reload.password_digest
      end

      test 'should send the user an email when email_address is found' do
        user = create(:user)
        post :create, email_address: user.email_address, use_route: :shoppe
        mail = ActionMailer::Base.deliveries.last
        assert_equal user.email_address, mail['to'].to_s
      end

      test 'should set notice when email_address is found' do
        user = create(:user)
        post :create, email_address: user.email_address, use_route: :shoppe
        assert_not_nil flash[:notice]
      end
    end
  end
end
