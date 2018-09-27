require 'beaker-puppet'
require 'beaker-rspec/helpers/serverspec'
require 'beaker-rspec/spec_helper'
require 'spec_helper_constants.rb'

RSpec.configure do |c|

  hosts.each do |host|
    shell('rpm -Uvh https://yum.puppetlabs.com/puppet5/el/7/x86_64/puppet5-release-5.0.0-4.el7.noarch.rpm')
    shell('yum -y install puppet')
    shell('rm -rf /etc/puppetlabs/code/hiera*')
    scp_to(host, File.join(HIERA_ROOT, 'hiera-acceptance.yaml'), '/etc/puppetlabs/code/hiera.yaml')
    scp_to(host, File.join(HIERA_ROOT, 'data'), '/etc/puppetlabs/code/hieradata')
    scp_to(host, File.join(ENV['HOME'], '.ssh/id_rsa'), '/root/.ssh/id_rsa')
    shell('ssh-keyscan -H github.com >> /root/.ssh/known_hosts')
    shell('chmod 600 /root/.ssh/id_rsa')
  end

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do

    # Install the module (and all of its custom module dependencies)
    if MODULES.empty?
      hosts.each do |host|
        install_dev_puppet_module_on(host, :source => PROJECT_ROOT, :module_name => MODULE_NAME)
      end
    end
    MODULES.each do |mname, mdir|
      module_path = File.expand_path(mdir.sub('#{source_dir}', PROJECT_ROOT))
      hosts.each do |host|
        install_dev_puppet_module_on(host, :source => module_path, :module_name => MODULE_NAME,
                                     :target_module_path => '/etc/puppetlabs/code/modules')
      end
    end

    # Install any 3rd party dependencies (add additional as needed)
    if ! FORGE_MODULES.empty?
      hosts.each do |host|
        FORGE_MODULES.each do |name, forge_name|
          on host, puppet('module', 'install', forge_name), { :acceptable_exit_codes => [0,1] }
          mpath = File.expand_path(name, "#{PROJECT_ROOT}/spec/fixtures/modules")
          if File.directory?(mpath)
            install_dev_puppet_module_on(host, :source => mpath, :module_name => name,
                                         :target_module_path => '/etc/puppetlabs/code/modules')
          else
            on host, puppet('module', 'install', forge_name), { :acceptable_exit_codes => [0,1] }
          end
        end
      end
    end

    if ! REPOSITORIES.empty?
      hosts.each do |host|
        shell('yum -y install git')
        REPOSITORIES.each do |name, details|
          shell("[ ! -d /etc/puppetlabs/code/modules/#{name} ] && git clone #{details['repo']} /etc/puppetlabs/code/modules/#{name} || true")
          if details['branch']
            shell("cd /etc/puppetlabs/code/modules/#{name} && git checkout #{details['branch']}")
          end
        end
      end
    end

  end
end
