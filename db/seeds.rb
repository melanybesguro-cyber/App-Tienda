admin = User.find_or_initialize_by(email: "admin@artelier.com")

admin.name = "Administrador"
admin.password = "admin123"
admin.password_confirmation = "admin123"
admin.role = "admin"

admin.save!

artist = User.find_or_initialize_by(email: "artista@artelier.com")

artist.name = "Artista de Prueba"
artist.password = "artist123"
artist.password_confirmation = "artist123"
artist.role = "artist"

artist.save!

customer = User.find_or_initialize_by(email: "cliente@artelier.com")

customer.name = "Cliente de Prueba"
customer.password = "customer123"
customer.password_confirmation = "customer123"
customer.role = "customer"

customer.save!