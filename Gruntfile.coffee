#global module:false
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig({
  # Metadata.
    meta:
      version: '0.1.0'
    banner: '/* Copyright (c) <%= grunt.template.today("yyyy") %> ' + 'Kyle Newsome Licensed MIT */\n'
  # Task configuration.

    gitclone:
      mousetrap:
        options:
          repository: 'https://github.com/ccampbell/mousetrap.git'
          branch: 'master'
          directory: 'app/other_components/mousetrap'
      hotkeys:
        options:
          repository: 'https://github.com/chieffancypants/angular-hotkeys.git'
          branch: 'master'
          directory: 'app/other_components/hotkeys'

    copy:
      dist:
        files: [
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/bower_components'
            dest: 'js/vendor/jquery'
            src: 'jquery/dist/jquery.min.js'
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/bower_components'
            dest: 'js/vendor/jquery'
            src: 'jquery-ui/ui/minified/jquery-ui.min.js'
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/bower_components'
            dest: 'js/vendor/angularjs'
            src: 'angular*/*.min.js*'
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/bower_components'
            dest: 'js/vendor/angularjs'
            src: 'angular-dragdrop/src/*.min.js*'
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/other_components/hotkeys/build'
            dest: 'js/vendor/angularjs'
            src: 'hotkeys.min.js'
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/other_components/hotkeys/build'
            dest: 'css'
            src: 'hotkeys.min.css'
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: 'app/other_components/mousetrap'
            dest: 'js/vendor/mousetrap'
            src: 'mousetrap.min.js'
          }
        ]

    coffee:
      compile:
        options:
          banner: '<%= banner %>',
          bare: true
        files: [
          {
            'js/index.js': [
              'js/index.coffee',
              'js/job-cards.coffee',
              'js/event-cards.coffee',
              'js/weather-cards.coffee',
              'js/business-object.coffee'
            ]
          }
        ]

    jade:
      dist:
        options:
          data:
            debug: false
        files:
          "index.html": ["index.jade"]

    compass:
    #options:
    #  importPath: 'app/bower_components'
      dist:
        options:
          config: "config.rb"

    watch:
      pages:
        files: ['**/*.jade']
        tasks: ['jade']
      scripts:
        files: ['**/*.coffee']
        tasks: ['coffee']
      css:
        files: ['**/*.sass']
        tasks: ['compass']
  })

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-git'

  # Default task.
  grunt.registerTask 'default', ['copy', 'jade', 'compass', 'coffee', 'watch']
  grunt.registerTask 'robert', ['jade', 'coffee', 'watch']
