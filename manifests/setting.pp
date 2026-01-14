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
  Enum['present']  $ensure = 'present',
  Optional[String] $value = undef,
  Hash             $settings = {},
) {
  assert_type(Pattern['^[a-z0-9A-Z_]+(/[a-z0-9A-Z_]+)+$'], $title)
  $_base_dir = '/etc/sysfs.d'

  $_value = pick_default($value, $settings[$value], undef)

  include sysfs

  $_dotted = regsubst($title, '/', '.', 'G')
  
  file { "${_base_dir}/${_dotted}.conf":
    ensure => $ensure,
    owner => 'root',
    group => 'root',
    mode  => '0644',
    content => "# Managed by Puppet\n${title} = ${_value}\n",
    notify => Exec['sysfsutils-reload'],
  }
}
