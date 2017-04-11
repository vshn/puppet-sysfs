# == Class: sysfs
#
# This module configures sysfs settings.
# 
# === Hiera example
#
# sysfs::settings:
#   'kernel/mm/transparent_hugepage/enabled': 'never'
#
# === Puppet example
#
# sysfs::setting { 'kernel/mm/transparent_hugepage/enabled':
#   value => 'never',
# }
#
# === Authors
#
# David Gubler <david.gubler@vshn.ch>
#
# === Copyright
#
# Copyright 2017 David Gubler, VSHN AG
#
class sysfs (
  $settings = {},
) {
  validate_hash($settings)
  $_base_dir = '/etc/sysfs.d'
  ensure_packages(['sysfsutils'])
  file { $_base_dir:
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['sysfsutils'],
    notify  => Exec['sysfsutils-reload'],
  }
  $_keys = keys($settings)
  sysfs::setting { $_keys:
    settings => $settings,
  }
  exec { "sysfsutils-reload":
    command => '/etc/init.d/sysfsutils restart',
    refreshonly => true,
  }
}
