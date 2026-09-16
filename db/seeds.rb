admin = User.find_or_initialize_by(email: "admin@artelier.com")

admin.name = "Administrador"
admin.password = "admin123"
admin.password_confirmation = "admin123"
admin.role = "admin"

admin.save!