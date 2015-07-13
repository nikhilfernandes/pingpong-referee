FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@pingpong.com"
  end 

  sequence :identity do |n|
    "identity#{n}"
  end 


  factory :referee do    
    email { generate(:email) }
    password 'password'    
  end

  factory :championship do    
    title "title"
  end

  factory :game do    
    championship
  end

  factory :player do    
    championship 
    name "name"
    identity { generate(:identity)}
    defence_length 7
    host "host"
    port "port"
    path "path"
  end

    
end
