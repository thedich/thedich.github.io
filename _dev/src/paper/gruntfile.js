
// grunt cli exec relative of node-modules installed with option -g (global)
// --base C:\Users\dich\AppData\Roaming\npm (global install)
// --gruntfile C:\Users\dich\Desktop\Git Page\thedich.github.io\dev\src\dude\gruntfile.js

var propath = __dirname.replace(/\\/gi,"/");
var pathdirs = propath.split("/");
pathdirs.pop(); pathdirs.pop(); pathdirs.pop();
var copypath = pathdirs.join('/');

console.log("__PATH__:"      + propath);
console.log("__COPY_PATH__:" + copypath);

module.exports = function(grunt) {

    grunt.initConfig({

        concat: {
            main: {
                src  : propath +'/input/*.js',
                dest : propath +'/input/concat/scripts.js',
                path : propath
            }
        },

        uglify: {
            main: {
                files: {
                    '<%= concat.main.path %>/output/js/dude.min.js': '<%= concat.main.dest %>'
                }
            }
        },

        less:{
            main:{
                src  : propath + '/input/less/*.less',
                dest : propath + '/input/less/css/lopaper.css'
            }
        },

        cssmin:{
            main:{
                src  : propath + '/input/less/css/**/*.css',
                dest : propath + '/output/css/lopaper.min.css'
            }
        },

        copy:{
            main:{

                files: [
                    {
                        expand : true,
                        cwd    : propath + '/output/',
                        src    : '**',
                        dest   : copypath + '/self/paper/'
                    }
                ]
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('default', ['concat', 'uglify', 'less', 'cssmin' , 'copy']);
};