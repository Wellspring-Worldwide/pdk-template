include ../../etc/makefiles/*.mk

clean:
	rm -rf ./log ./junit ./spec/fixtures/*;\
	$(MAKE) vagrant-destroy

deps:
	mkdir -p ./log
	bundle install >> ./log/bundle_install.log

update: deps
	cp metadata.json{,~}; pdk update; mv metadata.json{~,}

test: deps
	bundle exec rake test

acceptance: deps vagrant-destroy
	bundle exec rake acceptance BEAKER_destroy=no &&\
	$(MAKE) vagrant-destroy

inspect: deps vagrant-destroy
	bundle exec rake acceptance BEAKER_destroy=no;\
	pushd .vagrant/beaker_vagrant_files/default.yml; vagrant ssh; popd

vagrant-destroy:
	test -d .vagrant && pushd .vagrant/beaker_vagrant_files/default.yml || exit 0;\
	vagrant destroy --force > /dev/null 2>&1 || vagrant destroy --force &&\
	popd && rm -rf .vagrant;

PHONY: test accpetance inspect clean vagrant-destroy
