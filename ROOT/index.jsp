<%--
    Document   : index
    Created on : 12.10.2015, 11:55:32
    Author     : vojtisek ondrej (ondrej.vojtisek@mou.cz, ondra.vojtisek@gmail.com)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Database of virtual slides</title>
        <link rel="stylesheet" type="text/css" href="./css/login.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    </head>

    <body>

        <div id="mother">
            <div id="header">

                <div style="background: #434343; height: 27px; width: 100%; float: left;"></div>

                <div class="inner row">

                    <a href="http://www.recamo.cz" id="logo">
                        <img src="./images/logo.png" width="347" height="101" alt="RECAMO - Regional Centre for Applied Molecular Oncology">
                    </a>
                    <ul id="pagesmenu"></ul>
                    <ul id="langmenu"></ul>

                    <div id="mainmenu" class="row">

                        <ul class="col col-1"></ul>

                        <ul class="col col-2"></ul>

                    </div>
                    <a href="http://www.mou.cz" id="logo-mou" class="external"><img src="./images/logo-mou-en.png" width="74" height="74" alt="Masaryk Memorial Cancer Institute"></a>
                </div>
            </div>




            <div id="main">
                <div class="inner">
                    <div class="row claim" style="margin-bottom: 120px;">
                        <div style="padding-top: 40px;">

                            <h1>Database of virtual slides</h1>

			
				<%@include file="slide_printer.jsp" %>                         





                        </div>
                    </div>
                </div>
            </div>
            <div style="position: absolute; bottom: 0; height: 270px; width: 100%;" >
                <div class="inner"><i>Based on <a href="http://jvsmicroscope.uta.fi/">jvsmicroscope</a> - software of Jorma Isola & Vilppu Tuominen, University of Tampere used for conversion to jpeg 2000,
                        and <a href="http://iipimage.sourceforge.net/">IIPImage</a> for online view of slides. Server installed according to how-to published
                        at <a href="http://help.oldmapsonline.org/jpeg2000/installation">oldmapsonline.org<a/>.</i> </div>
            </div>

            <div id="footer">
                <div class="inner row">
                    <div class="col col-1">
                        <a href="http://www.recamo.cz/en/#" class="logo" id="logo-msmt"><img src="./images/logo-msmt-en.png" width="121" height="57" alt="Ministerstvo školství, mládeže a tělovýchovy"></a>
                        <a href="http://www.recamo.cz/en/#" class="logo" id="logo-eu"><img src="./images/logo-eu-en.png" width="247" height="36" alt="Evropská unie - Evropský fond pro regionální rozvoj - Investice do vaší budoucnosti"></a>
                        <a href="http://www.recamo.cz/en/#" class="logo" id="logo-opvavpi"><img src="./images/logo-opvavpi-en.png" width="116" height="62" alt="OP Research and Developmnet for Inovation"></a>
                    </div>
                    <div class="col col-2">
                        <address>
                            <span class="upper">Regional Centre for Applied Molecular Oncology</span>
                            <span class="small">
                                <br>
                                Masaryk Memorial Cancer Institute<br>
                                Zluty kopec 7, 656 53 Brno<br>
                                Czech Republic<br>
                                tel.: +420 543 136 700<br>
                                e-mail: <a href="mailto:recamo@mou.cz">recamo@mou.cz</a>
                            </span>
                        </address>
                    </div>
                </div>
            </div>
        </div>




    </body>

</html>
