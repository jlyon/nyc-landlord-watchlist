'use strict';
var path = require('path');
//var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;

var folderMount = function folderMount(connect, point) {
  return connect.static(path.resolve(point));
};

module.exports = function (grunt) {
  // Project configuration.
  grunt.initConfig({
    // Configuration to be run (and then tested)
    watch: {
      options: {
        livereload: true,
      },
      coffee: {
        files: ['../src/coffee/*.coffee'],
        tasks: 'coffee:compile'
      }
    },

    /*coffeeredux: {
      options: {
        bare: true,
        sourceMap: true
      },
      compile: {
        files: {
          '../js/custom.js': ['../coffeescript/*.coffee']
        }
      }
    }*/
    coffee: {
      options: {
        bare: true,
        sourceMap: true
      },
      compile: {
        files: {
          '../src/js/leaflet.control.geosearch.js': '../src/coffee/leaflet.control.geosearch.coffee',
        }
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  //grunt.loadNpmTasks('grunt-contrib-jshint');

  grunt.registerTask('default', ['watch', 'compass', 'coffee']);
};
