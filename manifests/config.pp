class gitolite::config {
    $owner = 'gitolite3'
    $group = 'gitolite3'

    file { [
        '/var/lib/gitolite3',
        '/var/lib/gitolite3/.gitolite',
        '/var/lib/gitolite3/.gitolite/hooks',
        '/var/lib/gitolite3/.gitolite/hooks/common',
        '/var/lib/gitolite3/.gitolite/logs',
        # added conf to store admin.pub with ssh pubkey for gitolite setup runs
        '/var/lib/gitolite3/.gitolite/conf',
    ]:
        owner   => $owner,
        group   => $group,
        require => Package['gitolite3'],
        ensure  => directory,
    }

    file { '/var/lib/gitolite3/.gitolite/hooks/common/post-receive':
        owner   => $owner,
        group   => $group,
        mode    => '0755',
        ensure  => file,
        source => 'puppet:///modules/gitolite/post-receive',
    }

    file { '/var/lib/gitolite3/.gitolite/conf/admin.pub':
        owner   => $owner,
        group   => $group,
        mode    => '0600',
        ensure  => file,
        content => hiera('gitolite::config::admin_pub')
    }


    exec { "/usr/bin/gitolite setup -pk /var/lib/gitolite3/.gitolite/conf/admin.pub":
        user        => $owner,
        environment => 'HOME=/var/lib/gitolite3',
        subscribe   => [
          File['/var/lib/gitolite3/.gitolite/hooks/common/post-receive'],
          File['/var/lib/gitolite3/.gitolite/conf/admin.pub'],
        ],
        refreshonly => true
    }

    file { '/var/lib/gitolite3/.gitolite/hooks/common/git-notifier':
        owner   => $owner,
        group   => $group,
        mode    => '0755',
        ensure  => file,
        source => 'puppet:///modules/gitolite/git-notifier',
    }
}
