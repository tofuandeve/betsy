require "test_helper"
describe CategoriesController do
  let(:merchant1) { merchants(:merchant1) }

  describe "guest user" do
    describe "new" do
      it "redirects a guest user to the root path" do
        get new_category_path
        must_redirect_to root_path
      end
    end

    describe "create" do
      it "redirects to root when user not logged in" do
        category_hash = {
          name: "Trash",
        }

        post categories_path, params: category_hash
        must_redirect_to root_path
      end
    end
  end

  describe "logged in merchant" do
    before do
      perform_login
    end

    describe "new" do
      it "responds with success for a logged-in Merhant" do
        get new_category_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "successfully creates a new category and redirects when a logged-in Merchant gives valid info" do
        category_hash = {
          category: { name: "Rotten_Food" },
        }

        expect {
          post categories_path, params: category_hash
        }.must_differ "Category.count", 1

        must_redirect_to merchant_path(Merchant.find_by(id: session[:merchant_id]))
      end

      it "renders new and gives bad_request status for invalid info" do
        category_hash2 = { category: { name: "" } }

        expect {
          post categories_path, params: category_hash2
        }.must_differ "Category.count", 0

        must_respond_with :success
      end
    end
  end
end
