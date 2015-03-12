FactoryGirl.define do
	factory :user do |user|
		user.nom							"maxime boiraud"
		user.email						"mboir@gmail.com"
		user.password					"foobar"
		user.password_confirmation "foobar"
	end

	factory :micropost do |micropost|
		micropost.content "Foo bar"
		micropost.association :user
	end
end
