<%@ page language="java" pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" media="all" href="css/iip.css"/>
    <link rel="shortcut icon" href="images/iip-favicon.png"/>
    <title>IIPImage JPEG2000</title>

    <script type="text/javascript" src="javascript/mootools-core-1.6.0-compressed.js"></script>
    <script type="text/javascript" src="javascript/iipmooviewer-2.0-min.js"></script>

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
        var credit = 'Image visualization: IIPImage</br>Data source: <a href="www.recamo.cz">RECAMO</a>';

        // vytvoreni objektu pro zobrazeni jednoho obrazku v iipmooviewer (javascript knihovna)
        // popis parametru apod na webu http://iipimage.sourceforge.net/documentation/iipmooviewer/
        //iip = new IIP("targetframe", {
        //    image: images,
        //    server: server,
        //    credit: credit,
        //    zoom: 1,
        //    render: 'random',
        //   showNavButtons: true
        //});
        
        new IIPMooViewer( "viewer", { image: images } );

    </script>

</head>

<body>
    <div id="viewer" style="width:100%;height:100%"></div>
    <!--
    <div style="width:99%;height:99%;margin-left:auto;margin-right:auto" id="targetframe"></div>
    -->
</body>

</html>
