# Class profiles::elasticsearch
#
# Will install elasticsearch on a node.
#
# Sample Usage:
#   class { 'profiles::elasticsearch': }
#
class profiles::elasticsearch {

  class {'::elasticsearch' :
    manage_repo  => true,
    repo_version => 1.4,
    java_install => true
  }

  elasticsearch::instance { 'es-01': }
}
