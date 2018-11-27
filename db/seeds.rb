if AdminUser.find_by(email: 'admin@example.com').nil?
  AdminUser.create!(
    first_name: 'admin',
    last_name: 'user',
    email: 'admin@example.com', 
    password: 'password', 
    password_confirmation: 'password'
    )
end


if Currency.all.empty?
  Currency.create!(name: 'USD', course: 1)
  Currency.create!(name: 'EUR', course: 0.89)
  Currency.create!(name: 'GBP', course: 0.77)
  Currency.create!(name: 'CAD', course: 1.35)
end

if Category.all.empty?
  Category.create!(name: 'Toys', color: '#8dc4e3', static_image: 'category-logo/toys.png')
  Category.create!(name: 'Clothing', color: '#cd71a9', static_image: 'category-logo/clothing.png')
  Category.create!(name: 'Baby', color: '#d38585', static_image: 'category-logo/baby.png')
  Category.create!(name: 'Electronics', color: '#7fadde', static_image: 'category-logo/electronics.png')
  Category.create!(name: 'Handmade', color: '#af8f57', static_image: 'category-logo/handmade.png')
  Category.create!(name: 'Health & beauty', color: '#af86b8', static_image: 'category-logo/health&beauty.png')
  Category.create!(name: 'Home', color: '#d25656', static_image: 'category-logo/home.png')
  Category.create!(name: 'Jewelry', color: '#c5dbe3', static_image: 'category-logo/jewelry.png')
  Category.create!(name: 'Maternity', color: '#66868d', static_image: 'category-logo/maternity.png')
  Category.create!(name: 'Office', color: '#79604e', static_image: 'category-logo/office.png')
  Category.create!(name: 'Outdoor gear', color: '#acc85b', static_image: 'category-logo/outdoor_gear.png')
  Category.create!(name: 'School uniforms', color: '#616161', static_image: 'category-logo/school_uniforms.png')
  Category.create!(name: 'Sports & fitness', color: '#c9905e', static_image: 'category-logo/sports&fitness.png')
  Category.create!(name: 'Vehicles', color: '#acb660', static_image: 'category-logo/vehicles.png')
  Category.create!(name: 'Other', color: '#000000', static_image: 'category-logo/other.png')
end
