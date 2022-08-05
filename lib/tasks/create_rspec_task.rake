task initialize_rspec: :environment do
  system('bundle exec rails g rspec:model admin_user  email:string  name:string ')

  system('bundle exec rails g rspec:scaffold admin_user --controller_specs')

  system('bundle exec rails g rspec:controller dashboard/admin_user')

  system('bundle exec rails g rspec:model refresh_auth_token ')

  system('bundle exec rails g rspec:scaffold refresh_auth_token --controller_specs')

  system('bundle exec rails g rspec:model blacklisted_auth_token ')

  system('bundle exec rails g rspec:scaffold blacklisted_auth_token --controller_specs')

  system('bundle exec rails g rspec:controller dashboard/base')
  system('bundle exec rails g rspec:controller dashboard/session')
end
