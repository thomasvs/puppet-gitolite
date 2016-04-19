class gitolite::install {
    package { 'gitolite':
        ensure => "present",
    }
}
