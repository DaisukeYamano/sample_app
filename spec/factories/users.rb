FactoryGirl.define do
  factory :user do
    name      "Daisuke Yamano"
    email     "dai.biker@gmail.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end