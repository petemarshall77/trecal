email    = ENV.fetch("TREECAL_EMAIL",    "admin@treecal.local")
password = ENV.fetch("TREECAL_PASSWORD", "changeme123")

user = User.find_or_create_by!(email_address: email) do |u|
  u.password = password
  u.password_confirmation = password
end

puts user.previously_new_record? ? "Created user: #{user.email_address}" : "User exists: #{user.email_address}"
