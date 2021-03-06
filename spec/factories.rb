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
    number_of_players 8
  end

  factory :game do    
    championship
    player1_identity { generate(:email) }
    player2_identity { generate(:email) }
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

  factory :round do
    game
  end

    
end
