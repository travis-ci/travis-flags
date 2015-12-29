require 'factory_girl'
require 'support/models'

FactoryGirl.define do
  factory :repository, aliases: [:repo] do
    owner_name 'travis-ci'
    name       'travis-core'
  end

  factory :user do
  end

  factory :org, class: Org do
  end
end
