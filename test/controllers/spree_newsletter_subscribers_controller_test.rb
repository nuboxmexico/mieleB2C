require 'test_helper'

class SpreeNewsletterSubscribersControllerTest < ActionController::TestCase
  setup do
    @spree_newsletter_subscriber = spree_newsletter_subscribers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spree_newsletter_subscribers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spree_newsletter_subscriber" do
    assert_difference('SpreeNewsletterSubscriber.count') do
      post :create, spree_newsletter_subscriber: { active: @spree_newsletter_subscriber.active, email: @spree_newsletter_subscriber.email }
    end

    assert_redirected_to spree_newsletter_subscriber_path(assigns(:spree_newsletter_subscriber))
  end

  test "should show spree_newsletter_subscriber" do
    get :show, id: @spree_newsletter_subscriber
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spree_newsletter_subscriber
    assert_response :success
  end

  test "should update spree_newsletter_subscriber" do
    patch :update, id: @spree_newsletter_subscriber, spree_newsletter_subscriber: { active: @spree_newsletter_subscriber.active, email: @spree_newsletter_subscriber.email }
    assert_redirected_to spree_newsletter_subscriber_path(assigns(:spree_newsletter_subscriber))
  end

  test "should destroy spree_newsletter_subscriber" do
    assert_difference('SpreeNewsletterSubscriber.count', -1) do
      delete :destroy, id: @spree_newsletter_subscriber
    end

    assert_redirected_to spree_newsletter_subscribers_path
  end
end
