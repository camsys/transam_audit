source "https://rubygems.org"

# Declare your gem's dependencies in transam_spatial.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

gem 'active_record-acts_as', git: 'https://github.com/camsys/active_record-acts_as', branch: 'master' # use our fork

# To use debugger
# gem 'debugger'
gem 'transam_core', git: 'https://github.com/camsys/transam_core', branch: :qa
gem 'mysql2', "~> 0.5.1" # lock gem for dummy app
gem "capybara", '2.6.2' # lock gem for old capybara behavior on hidden element xpath
gem 'sass-rails'
gem 'rails-controller-testing'
gem 'awesome_print'

# This gem allows us to share githooks. Githooks in the .hooks folder can be checked
# in, and when "bundle install" is run this gem automatically creates symlinks into
# your local .git/hooks. If you have pre-existing hooks in .git/hooks, it will move
# them to .git/hooks/old and you can move them back at your leisure. Any hooks
# checked in to .hooks will be shared among the team. If you need to re-generate
# the symlinks,you can use 'bundle exec git-hookshot'
# add group not to run on travis because git-hookshot gem seems to have issues on travis
group :not_travis do
  gem "git-hookshot"
end
