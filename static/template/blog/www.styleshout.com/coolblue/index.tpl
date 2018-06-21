{{ define "index" }}<!DOCTYPE html>
<!--[if IE 7 ]>    <html class="ie7 oldie"> <![endif]-->
<!--[if IE 8 ]>    <html class="ie8 oldie"> <![endif]-->
<!--[if IE 9 ]>    <html class="ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html> <!--<![endif]-->
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
  <meta charset="utf-8"/>
  <meta name="description" content="{{.Description}}">
  <meta name="author" content="{{.Author}}">

  <title>{{.Title}}</title>

  <script src="/static/js/jquery-1.6.1.min.js"></script>

  <link rel="stylesheet" href="/static/kendo-ui/styles/kendo.common-material.min.css" />
  <link rel="stylesheet" href="/static/kendo-ui/styles/kendo.material.min.css" />
  <link rel="stylesheet" href="/static/kendo-ui/styles/kendo.material.mobile.min.css" />

  <script src="/static/kendo-ui/js/jquery.min.js"></script>
  <script src="/static/kendo-ui/js/kendo.all.min.js"></script>

  <link rel="stylesheet" href="/static/fonts/fontawesome/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">

  <link rel="stylesheet" type="text/css" media="screen" href="/static/template/blog/www.styleshout.com/coolblue/css/coolblue.css" />

  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <script src="/static/template/blog/www.styleshout.com/coolblue/js/scrollToTop.js"></script>
  <script src="/static/ace/ace.js" type="text/javascript" charset="utf-8"></script>
  <style>
    #aceEditor{
      width: 540px;
      height: 800px;
    }
  </style>
  {{htmlSafe .TelerikScriptTemplate}}
  <script>
    var dropdowntree;
    {{js .TelerikVarGlobal}}
    $(document).ready(function () {
      {{js .TelerikOnLoadCode}}
      var data = [
        {
          id: 1, text: "JavaScript", expanded: false, items: [
            { id: 2, text: "Tables & chairs" },
            { id: 3, text: "Sofas" },
            { id: 4, text: "Occasional furnitures" },
            { id: 5, text: "Childrens furniture" },
            { id: 6, text: "Beds" }
          ]
        },
        {
          id: 7, text: "Golang", expanded: false, items: [
            { id: 8, text: "Bed linen" },
            { id: 9, text: "Throws" },
            { id: 10, text: "Curtains & blinds" },
            { id: 11, text: "Rugs" },
            { id: 12, text: "Carpets" }
          ]
        },
        {
          id: 13, text: "AWS", expanded: false, items: [
            { id: 14, text: "Wall shelving" },
            { id: 15, text: "Kids storage" },
            { id: 16, text: "Multimedia storage" },
            { id: 17, text: "Floor shelving" },
            { id: 18, text: "Toilet roll holders" },
            { id: 19, text: "Storage jars" },
            { id: 20, text: "Drawers" },
            { id: 21, text: "Boxes" }
          ]
        }
      ];

      // create kendoDropDownTree from input HTML element
      $("#qsearch").kendoDropDownTree({
        placeholder: "search ...",
        filter: "startswith",
        height: "auto",
        dataTextField: "text",
        dataValueField: "id",
        dataSource: data,
        change: function(){
          console.log( dropdowntree.value() )
        }
      });

      dropdowntree = $("#qsearch").data("kendoDropDownTree"),
          setValue = function (e) {
            if (e.type != "keypress" || kendo.keys.ENTER == e.keyCode) {
              dropdowntree.dataSource.filter({}); //clear applied filter before setting value

              dropdowntree.value($("#value").val().split(","));
            }
          };

























      var useWebWorker = window.location.search.toLowerCase().indexOf('noworker') == -1;

      var editor = ace.edit("aceEditor"); // fixme: id do elemento aqui


      editor.getSession().setUseWorker(useWebWorker);
      editor.session.setMode("ace/mode/javascript");



      editor.setShowPrintMargin(false);
      editor.$blockScrolling = Infinity;//prevents ace from logging annoying warnings
      //#endregion

      ace.config.loadModule('ace/ext/tern', function () {
        editor.setOptions({
          /**
           * Either `true` or `false` or to enable with custom options pass object that
           * has options for tern server: http://ternjs.net/doc/manual.html#server_api
           * If `true`, then default options will be used
           */
          enableTern: {
            /* http://ternjs.net/doc/manual.html#option_defs */
            defs: ['browser', 'ecma5', 'db'],
            /* http://ternjs.net/doc/manual.html#plugins */
            plugins: {
              doc_comment: {
                fullDocs: true
              }
            },
            /**
             * (default is true) If web worker is used for tern server.
             * This is recommended as it offers better performance, but prevents this from working in a local html file due to browser security restrictions
             */
            useWorker: useWebWorker,
            /* if your editor supports switching between different files (such as tabbed interface) then tern can do this when jump to defnition of function in another file is called, but you must tell tern what to execute in order to jump to the specified file */
            switchToDoc: function (name, start) {
              //console.log('switchToDoc called but not defined. name=' + name + '; start=', start);
            },
            /**
             * if passed, this function will be called once ternServer is started.
             * This is needed when useWorker=false because the tern source files are loaded asynchronously before the server is started.
             */
            startedCb: function () {
              //once tern is enabled, it can be accessed via editor.ternServer
              //console.log('editor.ternServer:', editor.ternServer);
            },
          },
          /**
           * when using tern, it takes over Ace's built in snippets support.
           * this setting affects all modes when using tern, not just javascript.
           */
          enableSnippets: true,
          /**
           * when using tern, Ace's basic text auto completion is enabled still by deafult.
           * This settings affects all modes when using tern, not just javascript.
           * For javascript mode the basic auto completion will be added to completion results if tern fails to find completions or if you double tab the hotkey for get completion (default is ctrl+space, so hit ctrl+space twice rapidly to include basic text completions in the result)
           */
          enableBasicAutocompletion: true,
        });
      });

      //#region not relevant to tern (custom beautify plugin) and demo loading
      ace.config.loadModule('ace/ext/html_beautify', function (beautify) {
        editor.setOptions({
          // beautify when closing bracket typed in javascript or css mode
          autoBeautify: true,
          // this enables the plugin to work with hotkeys (ctrl+b to beautify)
          htmlBeautify: true,
        });

        //modify beautify options as needed:
        window.beautifyOptions = beautify.options;
      });


      function GetFile(file, c) {
        var xhr = new XMLHttpRequest();
        xhr.open("get", file, true);
        xhr.send();
        xhr.onreadystatechange = function () {
          if (xhr.readyState == 4) c(xhr.responseText, xhr.status);
        };
      }
    });
  </script>
  <base href="/static/template/blog/www.styleshout.com/coolblue/">
</head>

<body id="top">
<!--header -->
<div id="header-wrap">
  <header>
    <hgroup>
      <h1><a href="{{.HeaderLogo.Link}}">{{.HeaderLogo.Title}}</a></h1>
      <h6>{{.HeaderLogo.Label}}</h6>
    </hgroup>
    <nav>
      <ul>
      {{range .HeaderMenu}}{{if eq .Current true}}<li id="current">{{else}}<li>{{end}}<a href="{{.Link}}">{{.Label}}</a><span></span></li>{{end}}
      </ul>
    </nav>
    <!--div class="subscribe">
        <span>Subscribe:</span> <a href="#">Email</a> | <a href="#">RSS</a>
    </div-->
    <form id="quick-search" method="get" action="index.html">
        <input class="tbox" id="qsearch" style="width: 100%;" type="text" name="qsearch" />
    </form>
  </header>
</div>
<!--/header-->
<!-- content-wrap -->
<div id="content-wrap">
  <!-- content -->
  <div id="content" class="clearfix">
    <!-- main -->
    <div id="main">
    {{ template "mainContent" . }}
      <!-- /main -->
    </div>
    <!-- sidebar -->
    <div id="sidebar">

    {{if eq .SideBarEnable true }}
      {{range .SideBar}}
        {{ if eq .Type "SideBarAboutMe" }}
          {{ template "aboutMe" .Content }}
        {{ end }}{{ if eq .Type "SideBarSimpleMenu" }}
          {{ template "simpleMenu" .Content }}
        {{ end }}{{ if eq .Type "SideBarAdvertsMenu" }}
          {{ template "advertsMenu" .Content }}
        {{ end }}
      {{end}}
    {{end}}

    </div>
    <!-- /sidebar -->
  </div>
  <!-- content -->
</div>
<!-- /content-out -->
<!-- extra -->
<div id="extra-wrap"><div id="extra" class="clearfix">

  <!--div id="gallery" class="clearfix">
      <h3>Flickr Photos </h3>
      <p class="thumbs">
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      <a href="index.html"><img src="images/thumb.png" width="42" height="43" alt="thumbnail" /></a>
      </p>
  </div-->

  <!--div class="col first">
      <h3>Contact Info</h3>
      <p>
      <strong>Phone: </strong>+1234567<br/>
      <strong>Fax: </strong>+123456789
      </p>
      <p><strong>Address: </strong>123 Put Your Address Here</p>
      <p><strong>E-mail: </strong>me@coolblue.com</p>
      <p>Want more info - go to our <a href="#">contact page</a></p>
      <h3>Updates</h3>
      <ul class="subscribe-stuff">
          <li><a title="RSS" href="index.html" rel="nofollow">
          <img alt="RSS" title="RSS" src="images/social_rss.png" /></a>
          </li>
          <li><a title="Facebook" href="index.html" rel="nofollow">
          <img alt="Facebook" title="Facebook" src="images/social_facebook.png" /></a>
          </li>
          <li><a title="Twitter" href="index.html" rel="nofollow">
          <img alt="Twitter" title="Twitter" src="images/social_twitter.png" /></a>
          </li>
          <li><a title="E-mail this story to a friend!" href="index.html" rel="nofollow">
          <img alt="E-mail this story to a friend!" title="E-mail this story to a friend!" src="images/social_email.png" /></a>
          </li>
      </ul>
      <p>Stay up to date. Subscribe via
      <a href="index">RSS</a>, <a href="index">Facebook</a>,
      <a href="index">Twitter</a> or <a href="index">Email</a>
      </p>
  </div-->

  <!--div class="col">
      <h3>Site Links</h3>
      <div class="footer-list">
          <ul>
              <li><a href="index.html">Home</a></li>
              <li><a href="index.html">Style Demo</a></li>
              <li><a href="index.html">Blog</a></li>
              <li><a href="index.html">Archive</a></li>
              <li><a href="index.html">About</a></li>
              <li><a href="index.html">Template Info</a></li>
              <li><a href="index.html">Site Map</a></li>
          </ul>
      </div>
      <h3>Friends</h3>
      <div class="footer-list">
          <ul>
              <li><a href="index.html">consequat molestie</a></li>
              <li><a href="index.html">sem justo</a></li>
              <li><a href="index.html">semper</a></li>
              <li><a href="index.html">magna sed purus</a></li>
              <li><a href="index.html">tincidunt</a></li>
              <li><a href="index.html">consequat molestie</a></li>
              <li><a href="index.html">magna sed purus</a></li>
          </ul>
      </div>
  </div-->

  <!--div class="col">
      <h3>Credits</h3>
      <div class="footer-list">
          <ul>
              <li><a href="http://jasonlarose.com/blog/110-free-classy-social-media-icons">
                  110 Free Classy Social Media Icons by Jason LaRose
              </a>
              </li>
              <li><a href="http://wefunction.com/2009/05/free-social-icons-app-icons/">
                  Free Social Media Icons by WeFunction
              </a>
              </li>
              <li><a href="http://iconsweets2.com/">
                  Free Icons by Yummygum
              </a>
              </li>
          </ul>
      </div>
      <h3>Recent Comments</h3>
      <div class="recent-comments">
          <ul>
              <li><a href="index.html" title="Comment on title">Whoa! This one is really cool...</a><br /> &#45; <cite>Erwin</cite></li>
              <li><a href="index.html" title="Comment on title">Wow. This theme is really awesome...</a><br /> &#45; <cite>John Doe</cite></li>
              <li><a href="index.html" title="Comment on title">Type your comment here...</a><br />&#45; <cite>Naruto</cite></li>
              <li><a href="index.html" title="Comment on title">And don't forget this theme is free...</a><br /> &#45; <cite>Shikamaru</cite></li>
              <li><a href="index.html" title="Comment on title">Just a simple reply test. Thanks...</a><br /> &#45; <cite>ABCD</cite></li>
          </ul>
      </div>
  </div-->

  <!--div class="col">
      <h3>Archives</h3>
      <div class="footer-list">
          <ul>
              <li><a href="index.html">January 2010</a></li>
              <li><a href="index.html">December 2009</a></li>
              <li><a href="index.html">November 2009</a></li>
              <li><a href="index.html">October 2009</a></li>
              <li><a href="index.html">September 2009</a></li>
          </ul>
      </div>
      <h3>Recent Bookmarks</h3>
      <div class="footer-list">
          <ul>
              <li><a href="index.html">5 Must Have Sans Serif Fonts for Web Designers</a></li>
              <li><a href="index.html">The Basics of CSS3</a></li>
              <li><a href="index.html">10 Simple Tips for Launching a Website</a></li>
              <li><a href="index.html">24 ways: Working With RGBA Colour</a></li>
              <li><a href="index.html">30 Blog Designs with Killer Typography</a></li>
              <li><a href="index.html">The Principles of Great Design</a></li>
          </ul>
      </div>
  </div-->
</div></div>
<!-- /extra -->

<!-- footer -->
<footer>
  <p class="footer-left">&copy; 2018 Copyright <a href="{{.CopyrightLink}}" target="_blank">{{.Copyright}}</a>&nbsp;-&nbsp;Design original by <a href="http://www.styleshout.com/" target="_blank">styleshout</a> and modified by Helmut Kemper</p>
  <p class="footer-right">
    <a href="index.html">Home</a> |
    <!--a href="index.html">Sitemap</a> |
    <a href="index.html">RSS Feed</a> |-->
    <a href="#top" class="back-to-top">Back to Top</a>
  </p>
</footer>
<!-- /footer -->
</body>
</html>{{js .TelerikHtmlSupport}}{{ end }}