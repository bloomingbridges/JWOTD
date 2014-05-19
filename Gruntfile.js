module.exports = function(grunt) {
    
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        less: {
            options: {
                paths: ['src']
            },
            development: {
               expand: true,
               cwd: 'src/themes',
               src: '*.less',
               dest: 'build/css/',
               ext: '.css'
            }
        },

        coffee: {
            compile: {            
                files: {
                    'build/js/app.js': 'src/fetchWord.coffee'
                }
            }
        },

        copy: {
            markup: {
                files: [
                    // {expand: true, cwd: 'src', src: ['jwotd.appcache'], dest: 'build/'},
                    {expand: true, cwd: 'src', src: ['index.html'], dest: 'build/'},
                ]
            }
        }


    });

    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('themes', ['less']);
    grunt.registerTask('default', ['themes', 'coffee', 'copy']);

};