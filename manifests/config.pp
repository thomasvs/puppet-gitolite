class gitolite::config {
    $owner = 'gitolite'
    $group = 'gitolite'

    file { [
        '/var/lib/gitolite',
        '/var/lib/gitolite/.gitolite',
        '/var/lib/gitolite/.gitolite/hooks',
        '/var/lib/gitolite/.gitolite/hooks/common',
    ]:
        owner   => $owner,
        group   => $group,
        require => Package['gitolite'],
        ensure  => directory,
    }

    file { '/var/lib/gitolite/.gitolite/hooks/common/post-receive':
        owner   => $owner,
        group   => $group,
        mode    => '0755',
        ensure  => file,
        source => 'puppet:///modules/gitolite/post-receive',
    }

    exec { "/usr/bin/gl-setup":
        user => $owner,
        subscribe => File['/var/lib/gitolite/.gitolite/hooks/common/post-receive'],
        refreshonly => true
    }

    file { '/var/lib/gitolite/.gitolite/hooks/common/git-notifier':
        owner   => $owner,
        group   => $group,
        mode    => '0755',
        ensure  => file,
        source => 'puppet:///modules/gitolite/git-notifier',
    }
}
