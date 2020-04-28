#global module:false
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig({
  # Metadata.
    meta:
      version: '0.1.0'
    banner: '/* Copyright (c) <%= grunt.template.today("yyyy") %> ' + 'Kyle Newsome Licensed MIT */\n'
  # Task configuration.

    coffee:
      compile:
        options:
          banner: '<%= banner %>',
          bare: true
        files: [
          {
            'js/index.js': [
              'js/utilities.coffee',
              'js/components/**.coffee',

              'js/job-cards.coffee',
              'js/event-cards.coffee',
              'js/victory-conditions.coffee',
              'js/weather-cards.coffee',
              'js/victory-conditions.coffee',
              'js/business-object.coffee',

              'js/index.coffee',
            ]
          }
        ]

    jade:
      dist:
        options:
          pretty: yes
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
  grunt.registerTask 'default', ['jade', 'compass', 'coffee', 'watch']
