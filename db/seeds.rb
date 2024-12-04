# db/seeds.rb

[
  { name: 'Basic Package', credits: 10, price_cents: 1000 },   # $10.00
  { name: 'Standard Package', credits: 25, price_cents: 2500 }, # $25.00
  { name: 'Premium Package', credits: 50, price_cents: 5000 }   # $50.00
].each do |package|
  CreditPackage.find_or_create_by!(name: package[:name]) do |credit_package|
    credit_package.credits = package[:credits]
    credit_package.price_cents = package[:price_cents]
  end
end
