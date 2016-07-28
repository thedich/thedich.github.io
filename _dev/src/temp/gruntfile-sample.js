
// grunt cli exec relative of node-modules installed with option -g (global)
// --base C:\Users\dich\AppData\Roaming\npm (global install)
// --gruntfile C:\Users\dich\Desktop\Git Page\thedich.github.io\dev\src\dude\gruntfile.js

var propath = __dirname.replace(/\\/gi,"/"); console.log("__PATH__:" + propath);
module.exports = function(grunt) {

 // Задачи
    grunt.initConfig({

        typescript:{
            main:{
                src: propath + '/src/dev/typescript/*.ts',
                dest:propath + '/src/dev/js/tobuild/app.js'
            }
        },

     // Склеиваем
        concat: {
            main: {
                src: propath +'/src/dev/js/tobuild/**/*.js',  // Все JS-файлы в папке
                dest:propath +'/src/dev/js/scripts.js',
                path:propath
            }
        },

     // Сжимаем
        uglify: {
            main: {
                files: {
                  // Результат задачи concat
                    '<%= concat.main.path %>/src/build/js/scripts.min.js': '<%= concat.main.dest %>'
                }
            }
        },

        less:{
            main:{
                src: propath + '/src/dev/less/*.less',
                dest:propath + '/src/dev/css/kiosk.css'
            }
        },

        cssmin:{
            main:{
                src:propath + '/src/dev/css/**/*.css',
                dest:propath + '/src/build/css/kiosk.min.css'
            }
        }

        /*,copy: {
            main: {
                src:propath + 'src/dev/index.html',
                dest:propath + 'src/build/index.html'
                }
           }*/

        /*, writefile: {
            options: {
                data: { deploy:'//deploy'}
            },
            main: {
                src: 'src/build/js/scripts.min.js',
                dest: 'src/build/js/scripts.min.js'
            }
        }*/

    });

 // Загрузка плагинов, установленных с помощью npm install
    grunt.loadNpmTasks('grunt-typescript');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-copy');
 // grunt.loadNpmTasks('grunt-writefile');

 // Задача по умолчанию
    grunt.registerTask('default', ['typescript','concat', 'uglify', 'less', 'cssmin']);
};