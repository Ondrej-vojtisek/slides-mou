<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="DC.creator" content="Ruven Pillay &lt;ruven@users.sourceforge.netm&gt;"/>
  <meta name="DC.title" content="IIPMooViewer 2.0: HTML5 High Resolution Image Viewer"/>
  <meta name="DC.subject" content="IIPMooViewer; IIPImage; Visualization; HTML5; Ajax; High Resolution; Internet Imaging Protocol; IIP"/>
  <meta name="DC.description" content="IIPMooViewer is an advanced javascript HTML5 image viewer for streaming high resolution scientific images"/>
  <meta name="DC.rights" content="Copyright &copy; 2003-2016 Ruven Pillay"/>
  <meta name="DC.source" content="http://iipimage.sourceforge.net"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
  <meta http-equiv="X-UA-Compatible" content="IE=9" />

    <link rel="stylesheet" type="text/css" media="all" href="css/iip.min.css"/>

     <style type="text/css">
    body{
      height: 100%;
      padding: 0;
      margin: 0;
    }
    div#viewer{
      height: 100%;
      min-height: 100%;
      width: 100%;
      position: absolute;
      top: 0;
      left: 0;
      margin: 0;
      padding: 0;
    }	
  </style>	

    <link rel="shortcut icon" href="images/iip-favicon.png" />
    <link rel="apple-touch-icon" href="images/iip.png" />

    <title>IIPMooViewer 2.0 :: HTML5 High Resolution Image Viewer</title>

    <script type="text/javascript" src="javascript/mootools-core-1.6.0-compressed.js"></script>
    <script type="text/javascript" src="javascript/iipmooviewer-2.0-min.js"></script>

    <!--[if lt IE 7]>
  	<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE7.js">IE7_PNG_SUFFIX = ".png";</script>
    <![endif]-->

    <script type="text/javascript">

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                    results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        // definice volani backendu - musi sedet s nastavenim ve web.xml
        var server = '/cgi-bin/iipsrv.fcgi';

        // nazev souboru k zobrazeni predavany rozcestnikem
        var param = getParameterByName('path');

        // pokud nebyl predan zadny parametr - presmeruj na rozcestnik
        if (!param || 0 === param.length) {
            console.log("Path param empty");
            window.location = "https://slides.mou.cz";
        }

        // vytvoreni absolutni cesty k obrazku
        var images = '/mnt/slides/' + param;

        // copyright a dalsi informace, ktere se zobrazuji v zobrazeni detailu obrazku
        var credit = 'Image visualization: IIPMooViewer and IIIFServer. </br>Data source: <a href="www.recamo.cz">RECAMO</a>';

        // vytvoreni objektu pro zobrazeni jednoho obrazku v iipmooviewer (javascript knihovna)
        // popis parametru apod na webu http://iipimage.sourceforge.net/documentation/iipmooviewer/
         new IIPMooViewer("viewer", {
          image: images,
          server: server,
          credit: credit,
          zoom: 1
        });

    </script>
</head>

<body>
    <div id="viewer"></div>
</body>

</html>
