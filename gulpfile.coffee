###
Requires
###
path            = require 'path'
fs              = require 'fs'

gulp            = require 'gulp'
gulpsync        = require('gulp-sync')(gulp)

sourcemaps      = require 'gulp-sourcemaps'

gutil           = require 'gulp-util'
clean           = require "gulp-clean"
zip             = require 'gulp-zip'

# Server
coffee          = require 'gulp-coffee'

jsdoc           = require "gulp-jsdoc"

# General
uglify          = require 'gulp-uglify'
babel           = require 'gulp-babel'

rename          = require 'gulp-rename'

###
=====================================
Пути
=====================================
###

# Папки где находится проект
folders = 
    server:
        development:    "development"
        production:     "dist"

    general:
        docs:           "docs"
        release:        "release"

# Пути до задач
paths =
    # Клиентские файлы
    client:
        # Coffee
        coffee:
            from: [
                "./#{folders.server.development}/**/*.coffee"
                "!./#{folders.server.development}/**/_*.coffee"
            ]
            to:     "./#{folders.server.production}/"
            suffix: ".min"

    # Остальное
    general:
        # Документация
        jsdoc:
            from: [
                "./#{folders.server.production}/**/*.js"
                "!./#{folders.server.production}/node_modules/**/*.js"
            ]
            to: "./#{folders.general.docs}/"
        # Релизы
        release:
            from: [
                "./#{folders.server.production}/**/*"
                "./*.{json,js,yml,md,txt}"
                "!./"
                "!./#{folders.general.docs}/**/*"
                "!./#{folders.general.release}/**/*"
            ]
            to: "./#{folders.general.release}/"
        # Очистка предыдущей сборки
        clean:
            from: [
                "./#{folders.server.production}/**/*"
            ]

###
=====================================
Окружение
=====================================
###
$isProduction = false

###
=====================================
Функции
=====================================
###

###*
 * Обработчик ошибок
 * @param  {Error} err - ошибка
###
error = (err)->
    if err.toString
        console.log err.toString()
    else
        console.log err.message
    @.emit 'end'

###*
 * Получение версии пакета
 * @param  {String} placeholder - строка которая заменит версию пакета, если JSON файл поврежден
 * @return {String}             - версия пакета
###
getPackageVersion = (placeholder)->
    try
        packageFile = fs.readFileSync("./package.json").toString()
        packageFile = JSON.parse packageFile

        if packageFile?.version?
            version = "v#{packageFile.version}"
        else
            version = null
    catch e
        error e
        version = null

    if !version and placeholder
        version = "#{placeholder}"
    else if !version
        version = "v0.0.0"

    return version

###
=====================================
Задачи
=====================================
###
###
-------------------------------------
Клиент
-------------------------------------
###
# Coffee
gulp.task 'coffee', (next)->
    gulp.src paths.client.coffee.from
        # Source map
        .pipe if $isProduction then gutil.noop() else sourcemaps.init()
        # Рендер Coffee
        .pipe coffee({bare: true}).on 'error', error
        # Babel
        .pipe babel {
            presets: ['es2015']
        }
        # Минификация
        .pipe uglify()
        # Переименование
        .pipe rename {
            suffix: paths.client.coffee.suffix
        }
        # Сохринение Source Map
        .pipe if $isProduction then gutil.noop() else sourcemaps.write("./")
        # Сохранение
        .pipe gulp.dest paths.client.coffee.to
        .on 'error', error
        .on 'finish', next
        
    return

###
-------------------------------------
General
-------------------------------------
###
# Документация
gulp.task 'jsdoc', (next)->
    gulp.src paths.general.jsdoc.from
        # Рендер Cson
        .pipe jsdoc.parser().on 'error', error

        # Сохраниение в формате JSON
        # .pipe gulp.dest paths.general.jsdoc.to
        # Рендер в HTML документ
        .pipe jsdoc.generator paths.general.jsdoc.to
        .on 'error', error
        .on 'finish', next
    
    return

# Удаление сборки
gulp.task 'clean', (next)->
    gulp.src paths.general.clean.from, {read: false}
        # Удаление всего
        .pipe clean()
        .on 'error', error
        .on 'finish', next

    return

# Release
gulp.task 'release', (next)->
    time = new Date().getTime()
    version = getPackageVersion()

    gulp.src paths.general.release.from, { base: './' }
        .pipe zip "release-#{version}-#{time}.zip"
        .pipe gulp.dest paths.general.release.to
        .on 'error', error
        .on 'finish', next
    
    return

###
-------------------------------------
Settings
-------------------------------------
###
gulp.task 'settings:release', (next)->
    gutil.log gutil.colors.green "Switched to production settings"

    $isProduction = true

    next()

###
-------------------------------------
Watch
-------------------------------------
###
# Client
gulp.task 'watch:coffee', ->
    gulp.watch paths.client.coffee.from, gulpsync.sync [
        'coffee'
    ]

gulp.task 'watch:jsdoc', ->
    gulp.watch paths.general.jsdoc.from, gulpsync.sync [
        'jsdoc'
    ]

# Parent
gulp.task 'watch', gulpsync.async [
    'watch:coffee'
    # 'watch:jsdoc'
]

# Init
gulp.task 'build', gulpsync.sync [
    'clean'
    'coffee'
    # 'jsdoc'
]

gulp.task 'release', gulpsync.sync [
    'settings:release'
    
    'build'
    'release'
]

gulp.task 'default', gulpsync.sync [
    'build'
]