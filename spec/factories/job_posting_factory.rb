FactoryGirl.define do
  factory :job_posting, class: JobPosting do
    title { FFaker::Lorem.unique.sentence(3) }
    organisation { FFaker::Lorem.unique.sentence(3) }
    contact_name { FFaker::Name.unique.first_name }
    contact_email { FFaker::Internet.unique.email }
    contact_phone nil
    posting_date 2.weeks.ago
    closing_date 2.weeks.since
    status_cd 'open'
    description_markdown "# A cool job"
    remote false
    location 'Geneva'
    country 'Switzerland'
    page_views 33
  end
end