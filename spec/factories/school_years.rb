FactoryGirl.define do
  factory :school_year do
    start Date.new(2015, 8, 1)
    name { "#{start.year}-#{start.year + 1}" }

    factory :sy_2014_2015 do
      start Date.new(2014, 8, 1)
    end
    factory :sy_2013_2014 do
      start Date.new(2013, 8, 1)
    end
    factory :sy_2012_2013 do
      start Date.new(2012, 8, 1)
    end
  end
end
