require 'spec_helper'

describe "MicropostPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "micropost creation" do
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a micropost" do
				expect { click_button "Poster" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Poster" }
				it { should have_content('error') }
			end
		end

		describe "with valid info" do

			before { fill_in "micropost_content", with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Poster" }.to change(Micropost, :count).by(1)
			end
		end
	end
end
