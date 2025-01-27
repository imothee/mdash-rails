require "test_helper"

class MdashControllerTest < ActionDispatch::IntegrationTest
  test "should return a 500 if secret is not set" do
    Mdash.config.secret = nil
    get '/mdash/stats'
    assert_response :internal_server_error
  end

  test "should return a 500 if secret is too short" do
    Mdash.config.secret = "short"
    get '/mdash/stats'
    assert_response :internal_server_error
  end

  test "should throw 401 if the secret is not sent" do
    Mdash.config.secret = "longersecret"
    get '/mdash/stats'
    assert_response :unauthorized
  end

  test "should throw 401 if the secret is incorrect" do
    Mdash.config.secret = "longersecret"
    get '/mdash/stats', headers: { "X-Mdash-Token" => "incorrect" }
    assert_response :unauthorized
  end

  test "should return a 200 if the secret is correct" do
    Mdash.config.secret = "longersecret"
    get '/mdash/stats', headers: { "X-Mdash-Token" => "longersecret" }
    assert_response :ok
  end
end