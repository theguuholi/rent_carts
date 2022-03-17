%{
  "name" => "Gustavo",
  "drive_license" => "db123333",
  "email" => "adm@elxpro.com",
  "password" => "Abc@13212222",
  "password_confirmation" => "Abc@13212222",
  "user_name" => "adm",
  "role" => "ADMIN"
}
|> RentCarts.Accounts.create_user()

%{
  "name" => "Gustavo",
  "drive_license" => "db4444",
  "email" => "user@elxpro.com",
  "password" => "Abc@13212222",
  "password_confirmation" => "Abc@13212222",
  "user_name" => "USER"
}
|> RentCarts.Accounts.create_user()
