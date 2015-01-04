###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
page "/wow.html", :layout => false
page "/psn.html", :layout => false
page "/xbox.html", :layout => false
page "/steam.html", :layout => false
page "/fb.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

activate :directory_indexes

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :haml, { :ugly => true, :format => :html5 }

set :file_watcher_ignore, [
  /^\.bundle\//,
  /^\.sass-cache\//,
  /^\.git\//,
  /^\.gitignore$/,
  /\.DS_Store/,
  /^build\//,
  /^\.rbenv-.*$/,
  /^Gemfile$/,
  /^Gemfile\.lock$/,
  /~$/,
  /(^|\/)\.?#/,
  /^\.c9\//
]

# activate :livereload, :host => "status-dualmoon.c9.io"

# Build-specific configuration
configure :build do
  ignore '/wow.haml'
  ignore '/steam.haml'
  ignore '/psn.haml'
  ignore '/xbox.haml'
  ignore '/fb.haml'
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  #activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end