namespace :production do
	desc "A set of macros for building out and setting up operations on bitnami ec2"
	task :go => :environment do
		# Step 1: Alter the database.yml file
		mv "config/database.yml", "config/database.defunct.yml"
		File.open( "config/database.yml", "w" ) do |f|
			f.puts %Q(
production:
	adapter: mysql2
	encoding: utf8
	reconnect: false
	database: itrade_production
	pool: 5
	username: root
	password: bitnami
	socket: /opt/bitnami/mysql/tmp/mysql.sock
			) # f.puts
		end # File.Open
		sh "bundle exec rake db:create RAILS_ENV=production"
		sh "bundle exec rake db:schema:load RAILS_ENV=production"
		sh "bundle exec thin start -C config/itrade.yml"
	end # go
end # production
