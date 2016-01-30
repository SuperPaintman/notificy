# Notificy
[![Logo](/assets/logo.png)][example-url]

[**Notificy**][example-url] - beautiful, lightweight and fully customisable notifications to your website.

--------------------------------------------------------------------------------

## Jumppad
* [API](#api)
* [How to Use](#how-to-use)
* [Features](#features)
* [Changelog](#changelog)

--------------------------------------------------------------------------------

## Api
### Options
```js
var notes = $.notificy(/* there */); // <- 

note = notes.add("Text", /* or there */); // <- 
```

#### type
Type of note content.

If set to **html**, then the characters: **&** , **<** , **>** , **"** and **'** are replaced by: **&amp;** , **&lt;** , **&gt;** , **&quot;** , **&#39;** and **&#96;**

#### class
Class name of note

```js
type: String

default: "notificy"
```

#### id
ID name of note

```js
type: String

default: ""
```

#### element
HTML element wrapper of note

```js
type: String

default: "div"
```

#### container
Selector container of notes.

This should be an element of an absolute or fixed position!

```js
type: String

default: "body"
```

#### max
The maximum number of notes.

If set to **-1**, then you can add an infinite number of notes, else if it set to **0** - **Infinite** then when you add new notes, older will be deleted

```js
type: Number

default: -1
```

#### live
The lifetime of note in milliseconds.

If set to **-1**, then notes will not be removed (They will not have a lifetime)

```js
type: Number

default: 3000
```

#### dieDuration
Speed of note die animation in milliseconds

```js
type: Number

default: 300
```

#### dieAnimation
Type of note die animation

```js
type: String or Object

available values: "default", "fadeOut", "hide", "slideUp" 
    or jQuery like animation object
/*
jQuery animation object example:
{
      'height':           0
    , 'padding-top':      "0px"
    , 'padding-bottom':   "0px"
}
 */

default: "default"
```

#### dieCss
CSS styles that will be applied before note removed
This option is transferred to the **jQuery.css()**

```js
type: String or Object

available values: "default" or jQuery like animation 
/*
"default" is alias for:
{
    overflow: "hidden"
}
 */

default: "default"
```

#### addDuration
Speed of note add animation in milliseconds

```js
type: Number
default: 300
```

### Methods
#### NotesContainer\#add
Adds a new note to the container

##### Arguments
1. **text** *(String|Object)* : inner text / jQuery object
2. **[options={}]** *(Object)* : unique option for this note

##### Returns
1. *(Note)* : note object

##### Example
```js
var notes = $.notificy();

notes.add("test");
// or
notes.add("test", {
    live: 20
});
// or with jQuery inner
var $inner = $("<span>test</span>");
notes.add($inner);
```

#### NotesContainer\#remove
Remove the note from the container

##### Arguments
1. **note** *(Note)* : object of the note
2. **[die=true]** *(Boolean)* : play animations of die

##### Returns
1. *(Boolean)* : it was removed

##### Example
```js
var notes = $.notificy();

var note = notes.add("test");

notes.remove(note);
```

#### NotesContainer\#removeAll
Remove all notes from the container

##### Example
```js
var notes = $.notificy();

notes.add("test 1");
notes.add("test 2");
notes.add("test 3");

notes.removeAll();
```

#### NotesContainer\#removeOld
Remove the oldest last (n) notes from the container

##### Arguments
1. **n** *(Number)* : number of deleted notes

##### Example
```js
var notes = $.notificy();

notes.add("test 1");
notes.add("test 2");
notes.add("test 3");
notes.add("test 4");
notes.add("test 5");

notes.removeOld(3);

/*
Will be removed: "test 1", "test 2" and "test 3"
 */
```

#### Note\#on
Bind event on jQuery note's object

##### Arguments
1. **event** *(String)* : event name
2. **[handler=noop]** *(Function)* : event handler function

##### Example
```js
var notes = $.notificy();

var note = notes.add("test");

note.on("click", function(){});
```

#### Note\#die
kills note

##### Arguments
1. **[callback=noop]** *(Function)* : callback function

##### Example
```js
var notes = $.notificy();

var note = notes.add("test");

note.die();
// or
note.die(function(){
    console.log("Noooooooo!");
});
```

#### Note\#hide
hides note's DOM element

##### Example
```js
var notes = $.notificy();

var note = notes.add("test");

note.hide();
```

#### Note\#show
shows note's DOM element

##### Example
```js
var notes = $.notificy();

var note = notes.add("test");

note.show();
```

#### Note\#updateSize
Updates the information about the size of note's DOM element.

If you change size of note, don't forget to use this method!

##### Returns
1. *(Object)* : size of note element

##### Example
```js
var notes = $.notificy();

var note = notes.add("test");

note.updateSize();
```

--------------------------------------------------------------------------------

## How to Use
### Basic usage
It displays notifications at the bottom right

![Screenshot](/assets/screenshot-4.jpg)

```js
$(document).ready(function() {
    var notes, counter;

    // Init plugin
    notes = $.notificy({
          'type':   "plain"    // Escape Html chars
        , 'class':  "notificy" // Class name of the note
        , 'live':   3000       // Remove note after 3000ms
        , 'container': ".notificy-box--1"
    });

    counter = 0;
    // Bind click event for tests
    $('.examle-btn--1').on('click', function(){
        var inner, note;

        inner = "Hello " + (counter + 1) + "!";
        // Create note
        note = notes.add(inner);
        counter++;
    });
});
```

```css
.notificy-box--1 {
/* The container should be an absolute of fixed position */
  position: absolute;
  bottom: 0px; /* position Y */
  right: 0px; /* position X */
  overflow: hidden;
}
.notificy {
  width: 280px;
  margin: 14px;
  padding: 14px;
  border-radius: 4px;
  background: #fff;
  color: #4d4d4d;
  box-shadow: 1px 2px 4px rgba(77,77,77,0.3);
}
```

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Notificy - example</title>
    <link href="/css/default.css" media="all" rel="stylesheet"/>
    <script src="/js/jquery-2.1.4.min.js"></script>
    <script src="/js/notificy.min.js"></script>
  </head>
  <body>
    <div class="notificy-box--1">
      <!-- The container for notes -->
      
    </div>
    <button class="examle-btn--1">Click!</button>
  </body>
</html>
```

### It is custom!

![Screenshot](/assets/screenshot-2.jpg)

```js
$(document).ready(function() {
    var notes, $input;
    // Init plugin
    notes = $.notificy({
          'type':   "html"      // Insert like Html
        , 'class':  "n-message" // Class name of the note
        , 'live':   -1          // These notes will not be removed
        , 'max':    50          // But they may be no more than 50
        , 'container': ".n-messager--4"
    });

    $input = $('.examle-form--4 input[type="text"]');

    function sendMessage( text, user ) {
        var name = user == 1 ? "User" : "Bot";
        var now = new Date().toString();
        now = now.split(' ').slice(0, 5).join(' ');

        var html =  "<div class=\"n-avatar\">" +
                    "</div>" +
                    "<div class=\"n-content\">" +
                    "<h4>" + name + "</h4>" +
                    "<p>" + text + "</p>" +
                    "<span>" + now + "</span>" +
                    "<div class=\"clear\">" + 
                    "</div>" + 
                    "</div>"

        notes.add(html, {
            'class': "n-message n-message--user-" + user
        });
    };
    sendMessage("Hi, human!", 2);

    $('.examle-form--4').on("submit", function(e) {
        var text;
        e.preventDefault();
        text = $input.val();
        $input.val('');

        sendMessage(text, 1);

        // Very clever bot :D
        setTimeout(function(){
            var itWantsReply = Math.round(Math.random() * 100) > 30;
            if(itWantsReply){
                sendMessage("Hello!", 2);
            };
        },1000);
    });
});
```

```css
.clear {
  clear: both;
}
.n-messager--4 {
  position: absolute;
  bottom: 0px;
  left: 0px;
  width: 100%;
  margin-bottom: 50px;
  overflow: hidden;
}
.n-message {
  max-width: 280px;
  margin: 14px;
  padding: 14px;
  border-radius: 4px;
  background: #fff;
  color: #4d4d4d;
  word-break: break-all;
  overflow: hidden;
  box-shadow: 1px 2px 4px rgba(77,77,77,0.3);
}
.n-message .n-avatar {
  width: 64px;
  height: 64px;
  margin-right: 16px;
  border-radius: 50%;
  float: left;
}
.n-message .n-content {
  float: left;
}
.n-message .n-content h4,
.n-message .n-content p {
  margin: 0;
}
.n-message .n-content span {
  text-align: right;
  font-size: 80%;
}
.n-message--user-1 {
  margin-left: 10%;
  margin-right: auto;
}
.n-message--user-1 .n-avatar {
  background: #e6e6e6;
}
.n-message--user-2 {
  margin-left: auto;
  margin-right: 10%;
  background: #4d4d4d;
  color: #fff;
}
.n-message--user-2 .n-avatar {
  background: #5f5f5f;
}
.examle-form--4 {
  position: absolute;
  bottom: 0px;
  left: 0px;
  width: 100%;
}
.examle-form--4 input {
  display: block;
  width: 100%;
  margin: 0px;
  padding: 14px;
  border: none;
  background: #4d4d4d;
  color: #fff;
  box-sizing: border-box;
  outline: none;
}
```

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Notificy - example</title>
    <link href="/css/default.css" media="all" rel="stylesheet"/>
    <script src="/js/jquery-2.1.4.min.js"></script>
    <script src="/js/notificy.min.js"></script>
  </head>
  <body>
    <div class="n-messager--4"></div>
    <form class="examle-form--4">
      <input type="text" placeholder="Say hello">
    </form>
  </body>
</html>
```

### This can be a chat

![Screenshot](/assets/screenshot-1.jpg)

```js
$(document).ready(function() {
    var notes, $input;
    // Init plugin
    notes = $.notificy({
          'type':   "html"      // Insert like Html
        , 'class':  "n-message" // Class name of the note
        , 'live':   -1          // These notes will not be removed
        , 'max':    50          // But they may be no more than 50
        , 'container': ".n-messager--4"
    });

    $input = $('.examle-form--4 input[type="text"]');

    function sendMessage( text, user ) {
        var name = user == 1 ? "User" : "Bot";
        var now = new Date().toString();
        now = now.split(' ').slice(0, 5).join(' ');

        var html =  "<div class=\"n-avatar\">" +
                    "</div>" +
                    "<div class=\"n-content\">" +
                    "<h4>" + name + "</h4>" +
                    "<p>" + text + "</p>" +
                    "<span>" + now + "</span>" +
                    "<div class=\"clear\">" + 
                    "</div>" + 
                    "</div>"

        notes.add(html, {
            'class': "n-message n-message--user-" + user
        });
    };
    sendMessage("Hi, human!", 2);

    $('.examle-form--4').on("submit", function(e) {
        var text;
        e.preventDefault();
        text = $input.val();
        $input.val('');

        sendMessage(text, 1);

        // Very clever bot :D
        setTimeout(function(){
            var itWantsReply = Math.round(Math.random() * 100) > 30;
            if(itWantsReply){
                sendMessage("Hello!", 2);
            };
        },1000);
    });
});
```

```css

Bot
Hi, human!
Sun Jan 17 2016 15:52:29

Say hello
JavaScriptCSSHTML
.clear {
  clear: both;
}
.n-messager--4 {
  position: absolute;
  bottom: 0px;
  left: 0px;
  width: 100%;
  margin-bottom: 50px;
  overflow: hidden;
}
.n-message {
  max-width: 280px;
  margin: 14px;
  padding: 14px;
  border-radius: 4px;
  background: #fff;
  color: #4d4d4d;
  word-break: break-all;
  overflow: hidden;
  box-shadow: 1px 2px 4px rgba(77,77,77,0.3);
}
.n-message .n-avatar {
  width: 64px;
  height: 64px;
  margin-right: 16px;
  border-radius: 50%;
  float: left;
}
.n-message .n-content {
  float: left;
}
.n-message .n-content h4,
.n-message .n-content p {
  margin: 0;
}
.n-message .n-content span {
  text-align: right;
  font-size: 80%;
}
.n-message--user-1 {
  margin-left: 10%;
  margin-right: auto;
}
.n-message--user-1 .n-avatar {
  background: #e6e6e6;
}
.n-message--user-2 {
  margin-left: auto;
  margin-right: 10%;
  background: #4d4d4d;
  color: #fff;
}
.n-message--user-2 .n-avatar {
  background: #5f5f5f;
}
.examle-form--4 {
  position: absolute;
  bottom: 0px;
  left: 0px;
  width: 100%;
}
.examle-form--4 input {
  display: block;
  width: 100%;
  margin: 0px;
  padding: 14px;
  border: none;
  background: #4d4d4d;
  color: #fff;
  box-sizing: border-box;
  outline: none;
}
```

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Notificy - example</title>
    <link href="/css/default.css" media="all" rel="stylesheet"/>
    <script src="/js/jquery-2.1.4.min.js"></script>
    <script src="/js/notificy.min.js"></script>
  </head>
  <body>
    <div class="n-messager--4"></div>
    <form class="examle-form--4">
      <input type="text" placeholder="Say hello">
    </form>
  </body>
</html>
```

--------------------------------------------------------------------------------

## Features
* **Fast** - doesn't load the page unnecessary operations with the DOM tree.
* **Easy** - simple to use and expansion
* **Сustomisable** - adjust the appearance and behavior as you like. It can even be a chat!
* **Lightweight** - only 6,2kB
* **jQuery Plugin**
* **Cross-browser**

--------------------------------------------------------------------------------

## Changelog
### v 1.0
* Initial version

[example-url]: http://github.flatdev.ru/project/notificy/