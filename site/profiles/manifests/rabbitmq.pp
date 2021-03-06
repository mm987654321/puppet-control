# Class profiles::rabbitmq
#
# This class will manage rabbitmq installations
#
# Parameters:
#  ['port']    - Port which RabbitMQ should listen on. Defaults = 5672
#  ['version'] - Version of RabbitMQ to install. Default = 3.4.4
#
# Requires:
# - puppetlabs/rabbitmq
# - garethr/erlang
#
# Sample Usage:
#   class { 'profiles::rabbitmq':
#     version => '3.4.4'
#   }
#
class profiles::rabbitmq(

  $port     = 5672,
  $version  = '3.4.4',

){

  # Load SELinuux policy for RabbitMQ
  selinux::module { 'rabbit':
    ensure => 'present',
    source => 'puppet:///modules/profiles/rabbit.te'
  }

  # Red Hat uses weird version numbers
  if $::osfamily == 'RedHat' {
    $ver = "${version}-1"
    class { 'erlang': epel_enable => true }
  } else {
    $ver = $version
    package { 'erlang-base': ensure => 'latest' }
  }

  include ::erlang

  class { '::rabbitmq':
    version           => $ver,
    port              => $port,
    require           => Class[erlang],
    delete_guest_user => true
  }

  include stdlib

  create_resources('rabbitmq_user', hiera_hash('rabbitmq_users'))
  create_resources('rabbitmq_user_permissions', hiera_hash('rabbitmq_user_permissions'))

}
