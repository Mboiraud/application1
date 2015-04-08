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
	
	factory :recommendation do |recommendation|
		recommendation.content "Foo barbar"
		recommendation.association :sender
		recommendation.association :receiver
		recommendation.category "Contenu web"
		recommendation.item "titre de film"
		recommendation.group "new"
	end
	
	factory :request do |request|
		request.content "Foo barbar"
		request.association :sender
		request.association :receiver
		request.category "Film"
		request.group "new"
	end
end
