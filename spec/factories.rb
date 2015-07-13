FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@pingpong.com"
  end 

  factory :referee do    
    email { generate(:email) }
    password 'password'    
  end

  factory :championship do    
    
  end

  factory :game do    
    
  end

    
end
