# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :filing, :class => Scraper::Edgar::Filing do
    cik { 9000+rand(1000000) }
    accession_number { "#{"%010d" % rand(1e10)}-#{"%02d" % rand(1e2)}-#{"%06d" % rand(1e6)}"  }
    company_name { Faker::Company.name }
    form_type { Scraper::Edgar::Filing::FORM_TYPES[rand(121)] }
    filed_on { Date.new( 2010 + rand(3), rand(12)+1, rand(28)+1 ) }
    file_name { "edgar/data/#{rand(1e6)}/#{"%010d" % rand(1e10)}-#{"%02d" % rand(1e2)}-#{"%06d" % rand(1e6)}.txt" }
  end  
end