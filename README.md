# Puppet module: auditd

This is a Puppet module for auditd based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Sean Alderman / alderhost.net

Official site: http://www.alderhost.net

Official git repository: http://github.com/salderma/puppet-auditd

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.

## CONTINUOUS TESTING

Branch Master:[![Build Status](https://travis-ci.org/salderma/puppet-auditd.png?branch=master)](https://travis-ci.org/salderma/puppet-auditd)
Branch Develop:[![Build Status Develop](https://travis-ci.org/salderma/puppet-auditd.png?branch=develop)](https://travis-ci.org/salderma/puppet-auditd)

## USAGE - Basic management

* Install auditd with default settings

        class { 'auditd': }

* Install a specific version of auditd package

        class { 'auditd':
          version => '1.0.1',
        }

* Disable auditd service.

        class { 'auditd':
          disable => true
        }

* Remove auditd package

        class { 'auditd':
          absent => true
        }

* Enable auditing without without making changes on existing auditd configuration *files*

        class { 'auditd':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'auditd':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'auditd':
          source => [ "puppet:///modules/example42/auditd/auditd.conf-${hostname}" , "puppet:///modules/example42/auditd/auditd.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'auditd':
          source_dir       => 'puppet:///modules/example42/auditd/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'auditd':
          template => 'example42/auditd/auditd.conf.erb',
        }

* Automatically include a custom subclass

        class { 'auditd':
          my_class => 'example42::my_auditd',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'auditd':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'auditd':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { 'auditd':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { 'auditd':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


