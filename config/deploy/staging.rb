# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
#role :app, %w{deploy@example.com}
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}

set :stage, :staging
set :rails_env, 'staging'
set :branch, 'staging'

server 'xxx.xxx.xxx.xxx', user: 'deploy', roles: %w{web app db}
