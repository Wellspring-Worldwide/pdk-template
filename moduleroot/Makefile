deps:
	bundle install

test: deps
	bundle exec rake test

acceptance: deps
	bundle exec rake acceptance

inspect: deps
	bundle exec rake acceptance BEAKER_destroy=no;\
	cd .vagrant/beaker_vagrant_files/default.yml;
