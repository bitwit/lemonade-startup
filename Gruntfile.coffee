#global module:false
module.exports = (grunt) ->
  # Project configuration.

  grunt.initConfig({
  # Metadata.
    meta:
      version: '0.1.0'
    banner: '/* Copyright (c) <%= grunt.template.today("yyyy") %> ' + 'Kyle Newsome Licensed MIT */\n'
  # Task configuration.

    copy:
      dist:
        files: [{
          expand: true
          flatten: true
          dot: true
          cwd: 'app/bower_components'
          dest: 'js/vendor/angularjs'
          src: 'angular*/*.min.js*'
        }]

    coffee:
      compile:
        options:
          banner: '<%= banner %>',
          bare: true
        files: [
          {
            'js/index.js':['js/index.coffee']
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

  # Default task.
  grunt.registerTask 'default', ['copy','jade','compass','coffee','watch']
