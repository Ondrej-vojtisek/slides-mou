<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <link rel="stylesheet" type="text/css" media="all" href="css/iip.compressed.css"/>
    <link rel="shortcut icon" href="images/iip-favicon.png"/>
    <title>IIPImage JPEG2000</title>

    <script type="text/javascript" src="javascript/mootools-1.2-core.js"></script>
    <script type="text/javascript" src="javascript/mootools-1.2-more.js"></script>
    <script type="text/javascript" src="javascript/iipmooviewer-1.1.js"></script>

    <script type="text/javascript">

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                    results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var server = '/cgi-bin/iipsrv.fcgi';

        // path to image
        // folder must be replaces after testing phase
        var param = getParameterByName('path');

        // pokud nebyl predan zadny parametr - presmeruj na tomcat
        if (!param || 0 === param.length) {
            console.log("Path param empty");
            window.location = "https://slides.mou.cz";
        }

        var images = '/mnt/slides/' + param;

        // Copyright or information message
        var credit = 'Image visualization: IIPImage</br>Data source: <a href="www.recamo.cz">RECAMO</a>';

        // Create our viewer object - note: must assign this to the 'iip' variable.
        // See documentation for more details of options
        iip = new IIP("targetframe", {
            image: images,
            server: server,
            credit: credit,
            zoom: 1,
            render: 'random',
            showNavButtons: true
        });

    </script>

</head>

<body>
    <div style="width:99%;height:99%;margin-left:auto;margin-right:auto" id="targetframe"></div>
</body>

</html>
