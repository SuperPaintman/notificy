###!
 * Notificy jQuery plugin
 * @author  SuperPaintman <SuperPaintmanDeveloper@gmail.com>
 * @site    blog.flatdev.ru
 * @version 1.0
###
###*
 * @todo сделайть фабрику для amd / exports / root 
 * @todo может возникнуть проблема, с => вместо ->
 * @todo сделать загрузку нотификаций без анимации
###
"use strict"
do ($ = jQuery)->
    ###*
     * Неэкранированные HTML эллементы
     * @constant {RegExp}
    ###
    REGEXP_UNESCAPED_HTML = /[&<>"'`]/g

    ###*
     * Правила замены HTML эллементов
     * @constant {Object}
    ###
    HTML_ESCAPES =
        '&': '&amp;'
        '<': '&lt;'
        '>': '&gt;'
        '"': '&quot;'
        "'": '&#39;'
        '`': '&#96;'

    ###*
     * Получение экрана для html токена
     * @param  {String} chr
     * @return {String}
    ###
    getEscapeHtmlChar = (chr)-> HTML_ESCAPES[chr]

    ###*
     * Экранирование HTML
     * @param  {String} string
     * @return {String}       
    ###
    escape = (string)-> string.replace(REGEXP_UNESCAPED_HTML, getEscapeHtmlChar)

    ###*
     * Функция заглушка
    ###
    noop = ->

    class NotesContainer
        constructor: (@options = {})->
            @notes = []

            # Init
            if @options.container and typeof @options.container == "object" and @options.container != {}
                # jQuery object
                @container = @options.container
            else
                # Css selector
                @container = $( @options.container )
            
            @position = @._getPosition()

        ###*
         * Добавляет новый Note
         * @param {String|Object}   text    - Текст или jQuery объект
         * @param {Object}          options - Индивидуальные параметры
        ###
        add: (text, options = {})=>
            note = new Note( text, @options, options )
            note.parent = @

            note.hide()

            if @position.y == "top"
                @container.prepend( note.element )
            else
                @container.append( note.element )

            @notes.push( note )

            # Перемещение его вниз
            note._born("old", @position.y)

            # Установка смерти нотификации
            if note.options['live'] >= 0
                setTimeout =>
                    note.die()
                , note.options['live']

            # Обновление
            @._update()

            return note

        ###*
         * Удаляет одну нотификацию
         * @param  {Note}       note
         * @param  {Boolean}    [die=true]
         * @return {Boolean}        - Успешно ли удаление
        ###
        remove: (note, die = true)=>
            index = @notes.indexOf( note )
            if index > -1
                @notes.splice(index, 1)

                if die then note.die()

                # Обновление
                @._update()
                return true

            return false

        ###*
         * Удаляет все нотификаци
        ###
        removeAll: =>
            for index, note of @notes
                do (note)=>
                    @.remove(note, true)

        ###*
         * Удаляет N последних нотификаций
         * @param  {Number}       n
        ###
        removeOld: (n)=>
            notes = @notes[...n]

            for index, note of notes
                do (note)=>
                    @.remove(note, true)

        ###*
         * Обновляет все нотификации
        ###
        _update: =>
            notesCount = @notes.length
            for index, note of @notes
                note.show()

            if @options['max'] and @options['max'] >= 0
                if notesCount > @options['max']
                    @.removeOld( notesCount - @options['max'] )


        ###*
         * Получает позицию контейнера
         * @return {String} - top-left
         *                    top-right
         *                    bottom-left
         *                    bottom-right
        ###
        _getPosition: =>
            # Получение позиции
            if @position
                return @position
            else if @options['position'] and @options['position'] != "auto"
                switch @options['position']
                    when "top-left"
                        pos_y = "top"
                        pos_x = "left"
                    when "top-right"
                        pos_y = "top"
                        pos_x = "right"
                    when "bottom-left"
                        pos_y = "bottom"
                        pos_x = "left"
                    else
                        pos_y = "bottom"
                        pos_x = "right"

                return @position = {
                    x: pos_x
                    y: pos_y
                }
            else
                $containerPos = 
                    top:    @container.css("top")
                    left:   @container.css("left")
                    bottom: @container.css("bottom")
                    right:  @container.css("right")

                containerPos =
                    top:    if $containerPos.top     != ("auto" or "") then true else false
                    left:   if $containerPos.left    != ("auto" or "") then true else false
                    bottom: if $containerPos.bottom  != ("auto" or "") then true else false
                    right:  if $containerPos.right   != ("auto" or "") then true else false

                # Вверху
                if containerPos.top
                    pos_y = "top"
                # Внизу
                else
                    pos_y = "bottom"

                # Cлева
                if containerPos.left
                    pos_x = "left"
                # Справа
                else
                    pos_x = "right"

                return @position = {
                    x: pos_x
                    y: pos_y
                }

    class Note
        constructor: (@text, defaultOptions = {}, options = {})->
            if options and typeof options == "object" and options != {}
                @options    = $.extend {}, defaultOptions, options
            else
                @options    = defaultOptions

            # Init
            # @position   = undefined
            @size       = undefined

            @parent     = undefined

            @isShow     = undefined

            ###*
             * Класс присваеваемый шаблону
             * @type {String}
            ###
            html_class = ""
            if @options['class'] and @options['class'] != ""
                html_class = " class=\"#{ @options['class'] }\""

            ###*
             * ID присваеваемый шаблону
             * @type {String}
            ###
            html_id = ""
            if @options['id'] and @options['id'] != ""
                html_id = " id=\"#{ @options['id'] }\""

            ###*
             * Начало шаблона
             * @type {String}
            ###
            contentBefore  = "<#{ @options['element'] }#{ html_id }#{ html_class }>"
            
            ###*
             * Конец шаблона
             * @type {String}
            ###
            contentAfter   = "</#{ @options['element'] }>"

            ###*
             * Контент шаблона
             * @type {String}
            ###
            contentInner = @text

            if typeof contentInner == "string"
                switch @options['type']
                    when "plain"
                        contentInner = escape(contentInner)

                content = contentBefore + contentInner + contentAfter
                
                @element = $( content )
            else
                content = contentBefore + contentAfter

                @element = $( content ).append( contentInner )

        ###*
         * Установка эвентов
        ###
        on: (event, handler = noop)=>
            @element.on(event, handler)

        ###*
         * Удаление нотификацию
        ###
        die: (cb = noop)=>
            if @options['dieCss'] and @options['dieCss'] != "default"
                @element.css(@options['dieCss'])
            else
                @element.css {
                    overflow: "hidden"
                }


            if typeof @options['dieAnimation'] is "object"
                @element.animate @options['dieAnimation'], @.options['dieDuration'], =>
                    @element.remove()

                    # Вызов не через родителя
                    if @parent then @parent.remove( @, false )

                    cb?()
            else
                animation = false

                switch @options['dieAnimation']
                    when "fadeOut"
                        animation = "fadeOut"
                    when "hide"
                        animation = "hide"
                    when "slideUp"
                        animation = "slideUp"

                if animation
                    @element[ animation ] @.options['dieDuration'] , =>
                        @element.remove()

                        # Вызов не через родителя
                        if @parent then @parent.remove( @, false )

                        cb?()
                # Default
                else
                    @element.animate {
                        height: 0
                        'padding-top':      "0px"
                        'padding-bottom':   "0px"
                    }, @.options['dieDuration'], =>
                        @element.remove()

                        # Вызов не через родителя
                        if @parent then @parent.remove( @, false )

                        cb?()

        ###*
         * Создает нотификацию
        ###
        _born: (pos_x = "old", pos_y = "old", cb = noop)=>
            @size   = @._getSize()

            params = {}
            if pos_x and pos_x != "old"
                offsetX =   @size.width + 
                            @size.padding.left + @size.padding.right
                # if pos_x == "left" 
                #     offsetX += @size.margin.right
                # else
                #     offsetX += @size.margin.left

                oldMarginX = @size.margin[ pos_x ]
                params["margin-#{pos_x}"] = -1 * offsetX

            if pos_y and pos_y != "old"
                offsetY =   @size.height + 
                            @size.padding.top + @size.padding.bottom
                # if pos_y == "top" 
                #     offsetY += @size.margin.bottom
                # else
                #     offsetY += @size.margin.top

                oldMarginY = @size.margin[ pos_y ]
                params["margin-#{pos_y}"] = -1 * offsetY

            if (pos_x and pos_x != "old") or (pos_y and pos_y != "old")
                @element.animate params, 0, =>
                    params = {}
                    if pos_x and pos_x != "old"
                        params["margin-#{pos_x}"] = oldMarginX
                    if pos_y and pos_y != "old"
                        params["margin-#{pos_y}"] = oldMarginY
                    @element.animate params, @options['addDuration'], cb

        ###*
         * Скрывает нотификацию
        ###
        hide: =>
            if @isShow
                @element.hide()

                @isShow     = false

            return @

        ###*
         * Показывает нотификацию
        ###
        show: =>
            unless @isShow
                @element.show()

                @isShow     = true

            return @

        ###*
         * Получает размер нотификации
         * @return {Object} size
         * @return {Number} size.width
         * @return {Number} size.height
        ###
        _getSize: ->
            if @size
                return @size
            else
                return @.updateSize()

        ###*
         * Обновляет размер нотификации
         * @return {Object} size
         * @return {Number} size.width
         * @return {Number} size.height
        ###
        updateSize: ->
            @size = {
                width:      parseInt @element.width()
                height:     parseInt @element.height()

                margin: 
                    top:    parseInt @element.css("margin-top")
                    bottom: parseInt @element.css("margin-bottom")
                    left:   parseInt @element.css("margin-left")
                    right:  parseInt @element.css("margin-right")
                padding:
                    top:    parseInt @element.css("padding-top")
                    bottom: parseInt @element.css("padding-bottom")
                    left:   parseInt @element.css("padding-left")
                    right:  parseInt @element.css("padding-right")
            }

            return @size

    # Main
    $.notificy = (defaultOptions = {})->
        defaultOptions = $.extend {
            'type':         "plain"    # Html
            'class':        "notificy" # Класс присваеваемый для нотификатора
            'id':           ""         # ID присваеваемый для нотификатора
            'element':      "div"
            'container':    "body"
            'position':     "auto"
            'max':          -1
            'live':         3000
            'dieDuration':  300
            'dieAnimation': "default"
            'dieCss':       "default"
            'addDuration':  300
        }, defaultOptions

        return new NotesContainer(defaultOptions)