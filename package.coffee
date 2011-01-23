{
  name: 'mpd',
  description: 'Communicate with Music Player Daemon',
  keywords: [],
  version: '0.0.1',
  author: 'Feisty Studios <mpd@feistystudios.com> (http://feistystudios.com/)',
  licenses: [
    {
      type: 'FEISTY',
      url: 'http://github.com/feisty/license/raw/master/LICENSE'
    }
  ],
  contributors: ['Jacob Evans' <jacob.evans@feistystudios.com>'],
  repository: {
    type: 'git',
    url: 'http://github.com/dekz/coffee-mpd.git',
    private: 'git@github.com:dekz/coffee-mpd.git',
    web: 'http://github.com/dekz/coffee-mpd'
  },
  bugs: {
    mail: 'mpd@feistystudios.com',
    web: 'http://github.com/dekz/coffee-mpd/issues'
  },
  directories: {
    lib: './lib',
    doc: './doc'
  },
  dependencies: {
    'coffee-script': '>= 1.0.0'
  },
  engines: {
    node: '>= 0.2.5'
  }
}

