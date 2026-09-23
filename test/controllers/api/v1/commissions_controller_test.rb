require "test_helper"

class Api::V1::CommissionsControllerTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = %w[users orders commissions]

  test "creates a commission for the authenticated customer's order" do
    user = users(:one)
    user.update_column(:api_token, "test-token")

    post api_v1_commissions_url,
         params: {
           order_id: orders(:one).id,
           description: "Diseño de logo",
           deadline: "2026-10-01"
         },
         headers: {
           "Authorization" => "Bearer test-token",
           "Content-Type" => "application/json"
         },
         as: :json

    assert_response :created
    assert_equal "pending", Commission.order("created_at DESC").first.status
    assert_equal orders(:one).id, Commission.order("created_at DESC").first.order_id
  end

  test "rejects a commission without an order" do
    user = users(:one)
    user.update_column(:api_token, "test-token")

    post api_v1_commissions_url,
         params: { description: "Diseño de logo", deadline: "2026-10-01" },
         headers: {
           "Authorization" => "Bearer test-token",
           "Content-Type" => "application/json"
         },
         as: :json

    assert_response :unprocessable_entity
    assert_equal "Debés indicar el pedido de la comisión.", response.parsed_body["error"]
  end
end
