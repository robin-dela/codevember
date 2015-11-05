module.exports = (grunt) ->
  grunt.initConfig

    rubyHaml:
      app:
        files: grunt.file.expandMapping(['views/*.haml'], 'build/',
          rename: (base, path) ->
            base + path.replace(/\.haml$/, '.html').replace('views/', '')
        )

    less:
      options:
        style: "compressed",
        sourceMap: false
      app:
        files:
          'build/assets/stylesheet/styles.css': 'assets/stylesheet/styles.less'

    coffeelint:
      app:
        files:
          src: ['assets/**/*.coffee']

    coffee:
      options:
        sourceMap: false
      app:
        files:
          'build/assets/javascript/main.js': ['assets/javascript/**/*.coffee']

    copy:
      main:
        files: [
          {
            expand: true
            cwd: 'assets/images'
            src: '**/*'
            dest: 'build/assets/images'
          },
          {
            expand: true
            cwd: 'assets/fonts'
            src: '**/*'
            dest: 'build/assets/fonts'
          }
        ]

    watch:
      haml:
        files: ['views/**/*.haml']
        tasks: ['rubyHaml', 'notify:watch']

      coffee:
        files: ['assets/javascript/**/*.coffee']
        tasks: ['coffeelint', 'coffee', 'notify:watch']

      less:
        files: ['assets/stylesheet/**/*.less']
        tasks: ['less', 'notify:watch']
        options:
          nospawn: true

      build:
        files: ['build/assets/stylesheet/**/*.css', 'build/*.html', 'build/assets/javascript/**/*.js']
        options:
          livereload: true

      copy:
        files: ['assets/images/**/*','assets/fonts/**/*']
        tasks: ['copy', 'notify:watch']

    connect:
      server:
        options:
          port: 3333
          base: 'build'

    open:
      dev:
        path: 'http://localhost:3333/'
        app: 'Google Chrome'

    notify_hooks:
      enabled: true

    notify:
      watch:
        options:
          title: 'Task complete'
          message: 'Build files successfully updated'

      server:
        options:
          title: 'Server started'
          message: 'Server started at http://localhost:3333'

  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-ruby-haml'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-open'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'default', ['rubyHaml', 'less', 'coffeelint', 'coffee','copy']
  grunt.registerTask 'server', ['default', 'connect', 'notify:server', 'open:dev', 'watch']