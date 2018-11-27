# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.scss, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# setup bower components folder for lookup
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
Rails.application.config.assets.paths << Rails.root.join('node_modules')
# fonts
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
# images
Rails.application.config.assets.precompile << /\.(?:png|jpg)$/
# precompile vendor assets
Rails.application.config.assets.precompile += %w( base.js account/base.js)
Rails.application.config.assets.precompile += %w( base.css account/base.css)

# Controller assets
Rails.application.config.assets.precompile += [
    # Scripts
    'charts.js',
    'dashboard.js',
    'documentation.js',
    'elements.js',
    'extras.js',
    'forms.js',
    'maps.js',
    'multilevel.js',
    'pages.js',
    'tables.js',
    'widgets.js',
    'blog.js',
    'ecommerce.js',
    'forum.js',
    # Stylesheets
    'index.css',
    'dashboard.css',
    'documentation.css',
    'elements.css',
    'extras.css',
    'forms.css',
    'maps.css',
    'multilevel.css',
    'pages.css',
    'tables.css',
    'widgets.css',
    'blog.css',
    'ecommerce.css',
    'forum.css',
    'account/messages.css',
    # Custom js
    'angle/*.js',
    'modules/*.js',
    'validation/*',
    'bids.js',
    'draft_item.js',
    'jquery.storageapi.min.js',
    'rating.js',
    'users.js',
    'account.js',
    'browse.js',
    'flashes.js',
    'live-chat.js',
    'ratyrate.js',
    'active_admin.js',
    'charges.js',
    '_fotorama.js',
    'main.js',
    'referral.js',
    'withdraws.js',
    'active_group_banner.js',
    'county_select.js',
    'groups.js',
    'messages.js',
    'search.js',
    'currency.js',
    'images.js',
    'modals.js',
    'select_on_change.js',
    'application.js',
    'description_counter.js',
    'items.js',
    'side_menu.js',
    'disput_comments.js',
    'item_stages.js',
    'more_group_items.js',
    'smooth_scroll.js',
    'disputs.js',
    'jquery.raty.js',
    'pages.js',
    'tab-switcher.js',
    'feedbacks.js',
    'account/messages.js',
    'account/dashboard.js'
]
