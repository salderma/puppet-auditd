# Class: auditd::params
#
# This class defines default parameters used by the main module class auditd
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to auditd class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class auditd::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'audit',
  }

  $service = $::operatingsystem ? {
    default => 'auditd',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'auditd',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'auditd',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/audit',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/audit/auditd.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/auditd',
    default                   => '/etc/sysconfig/auditd',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/auditd.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/auditd',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/auditd',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/audit/auditd.log',
  }

  $port = ''
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = false

}
