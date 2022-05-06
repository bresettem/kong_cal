namespace :clean do
  task :server, [:environment] => :environment do |t, args|
    args.with_defaults(environment: 'development')
    puts "Cleaning assets in #{args.environment}"
    system("rake assets:clean RAILS_ENV=#{args.environment}")

    puts "Clobbering assets in #{args.environment}"
    system("rake assets:clobber RAILS_ENV=#{args.environment}")

    puts "Precompile the assets in #{args.environment}"
    system("rake assets:precompile RAILS_ENV=#{args.environment}")
  end
end