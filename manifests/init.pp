class ldap {
  include ldap::install, ldap::config, ldap::authconfig, ldap::service
}

class ldap::install {
  package { "nscd": ensure => present, }

  package { "nss-pam-ldapd": ensure => present, }

  package { "openldap-clients": ensure => present, }

}

class ldap::config {
  file { "/etc/nsswitch.conf":
    replace => "yes",
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///files/ldap/files/nsswitch.conf",
  }

  file { "/etc/login.defs":
    replace => "yes",
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///files/ldap/files/login.defs",
  }

  file { "/etc/openldap/cacerts/cacert.pem":
    replace => "yes",
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///files/ldap/files/cacert.pem",
  }

  file { "/etc/sudo-ldap.conf":
    replace => "yes",
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///files/ldap/files/sudo-ldap.conf",
  }

  file { "/etc/sysconfig/authconfig":
    replace => "yes",
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///files/ldap/files/authconfig",
  }

  file { "/etc/pam.d/system-auth":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///files/ldap/files/system-auth",
  }

  file { "/etc/pam.d/password-auth":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///files/ldap/files/password-auth",
  }

  file { "/etc/pam.d/sshd":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///files/ldap/files/sshd",
  }

  file { "/etc/pam.d/su":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///files/ldap/files/su",
  }

  file { "/etc/nslcd.conf":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///files/ldap/files/nslcd.conf",
  }

  file { "/etc/openldap/ldap.conf":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => "puppet:///files/ldap/files/ldap.conf",
  }

}

class ldap::authconfig {
  exec { 'authconfig':
    command => "/usr/sbin/authconfig --enableldap \
	--enableldapauth \
        --enableldaptls \
	--ldapserver='ldap://ldap-m.idc.server.cn' \
	--ldapbasedn='dc=server,dc=cn' \
	--enableshadow \
	--enablelocauthorize \
	--enablemd5 \
	--disablecache \
        --disablecachecreds \
        --disablesssd \
        --disablesssdauth \
        --enablemkhomedir \
	--update  "
  }
}

class ldap::service {
  service { "nslcd":
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
    require    => Class["ldap::config"],
  }
}

