class gitolite::install {
    package { 'gitolite3':
        ensure => "present",
    }
}
