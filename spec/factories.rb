FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@pingpong.com"
  end 

  factory :referee do    
    email { generate(:email) }
    password 'password'    
  end

  factory :championship do    
    title "title"
  end

  factory :game do    
    
  end

  factory :player do    
    championship 
    name "name"
    identity "identity"
    defence_length 7
  end

    
end
