dev: ## Run dev environnment
		RACK_ENV=development rackup -p 3030

console: ## Run console
		bundle exec irb -I. -r app.rb
