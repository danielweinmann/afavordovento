# Where the I18n library should search for translation files
# I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
# Whether or not to accept only available locales
I18n.config.enforce_available_locales = true
# List of available locales
I18n.config.available_locales = [:"pt-BR"]

# Set default locale to something other than :en (make sure that you either accept all locale values or do not enforce available locales)
I18n.default_locale = :"pt-BR"
