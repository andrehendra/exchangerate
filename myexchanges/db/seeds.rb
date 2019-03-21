5.times do
  Exchange.create({
      date: Faker::Date.between(8.days.ago, Date.today),
      from: Faker::Alphanumeric.alpha(3),
      to: Faker::Alphanumeric.alpha(3),
      rate: Faker::Number.normal(1, 0.5)
  })
end
