# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

#rajout perso B49 pour blueprint/css
Rails.application.config.assets.precompile += %w( blueprint/screen.css )
Rails.application.config.assets.precompile += %w( blueprint/print.css )
Rails.application.config.assets.precompile += %w( blueprint/ie.css )
Rails.application.config.assets.precompile += %w( custom.css )

#rajout B49 pourjavascript
#Rails.application.config.assets.precompile += %w( application )
