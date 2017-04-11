# == Class: sysfs::setting
#
# This module configures a single sysfs setting.
#
# === Parameters
#
# [*ensure*]
#   Whether the setting should be present or not.
#   Default: present
#
# [*value*]
#   The value of the setting.
#
# [*settings*]
#   Internal use only, do not use directly.
#
# === Authors
#
# David Gubler <david.gubler@vshn.ch>
#
# === Copyright
#
# Copyright 2017 David Gubler, VSHN AG
#
define sysfs::setting (
  $ensure = 'present',
  $value = undef,
  $settings = {},
) {
  validate_re($name, '^[a-z0-9A-Z_]+(/[a-z0-9A-Z_]+)+$', 'sysfs setting must be slash-separated')
  $_base_dir = '/etc/sysfs.d'

  if ( $value ) {
    $_value = $value
  } else {
    $_value = $settings[$value]
  }

  include sysfs

  $_dotted = regsubst($name, '/', '.', 'G')
  
  file { "${_base_dir}/${_dotted}.conf":
    ensure => $ensure,
    owner => 'root',
    group => 'root',
    mode  => '0644',
    content => "# Managed by Puppet\n${name} = ${_value}\n",
    notify => Exec['sysfsutils-reload'],
  }
}
