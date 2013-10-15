module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'

    coffeelint:
      options:
        no_empty_param_list:
          level: 'error'
        max_line_length:
          level: 'ignore'

      src: ['src/*.coffee']
      test: ['spec/*.coffee']

    shell:
      browserify:
        command: 'node_modules/.bin/browserify -t coffeeify spec/spec-helper.coffee -o spec/spec-helper.js'
        options:
          stdout: true
          stderr: true
          failOnError: true

      test:
        command: 'node_modules/.bin/coffee spec/headless-spec-runner.coffee'
        options:
          stdout: true
          stderr: true
          failOnError: true

    connect:
      server:
        options:
          port: 1337
          keepalive: true

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-connect')

  grunt.registerTask 'clean', -> require('rimraf').sync('space-pen.js')
  grunt.registerTask('lint', ['coffeelint:src', 'coffeelint:test'])
  grunt.registerTask('test', ['default', 'shell:browserify', 'shell:test'])
  grunt.registerTask('default', ['coffee', 'coffeelint'])
