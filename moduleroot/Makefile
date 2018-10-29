clean:
	rm -rf ./log ./junit ./spec/fixtures/*

deps:
	bundle install

test: deps
	bundle exec rake test

acceptance: deps vagrant-destroy
	bundle exec rake acceptance BEAKER_destroy=no;\
	$(MAKE) vagrant-destroy

inspect: deps vagrant-destroy
	bundle exec rake acceptance BEAKER_destroy=no;\
	pushd .vagrant/beaker_vagrant_files/default.yml; vagrant ssh; popd

vagrant-destroy:
	test -d .vagrant && \
	pushd .vagrant/beaker_vagrant_files/default.yml; vagrant destroy --force; popd;\
	rm -rf .vagrant;

PHONY: test accpetance inspect clean
