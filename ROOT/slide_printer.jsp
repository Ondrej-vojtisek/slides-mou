<%--
    Document   : index
    Created on : 12.10.2015, 11:55:32
    Author     : vojtisek ondrej (ondrej.vojtisek@mou.cz, ondra.vojtisek@gmail.com)
--%>

<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.net.HttpURLConnection" %>
<%@page import="java.io.File" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>


<%
    // Kontrolovana pripona - jine soubory se neyobrazuji
    final String SUFFIX_JP_2000 = ".jp2";
    // nazev parametru predavany rozcestniku. Ocekavan je format ROK_BIOPTICKE-CISLO o delce rok 4 znaky, biopticke cislo 4-6 znaku
    final String BIOPSY_PARAM_NAME = "biopsy";
    // hostname serveru
    final String HOSTNAME = "https://slides.mou.cz";
    // cesta k obrazkum - adresar je pripojen pres sambu
    final String SLIDES_REPOSITORY = "/mnt/slides";
    // adresa ktera slouzi k nacteni nahledu obrazku
    final String PREVIEW_ADDRESS = HOSTNAME + "/cgi-bin/iipsrv.fcgi?FIF=" + SLIDES_REPOSITORY;
    // parametry adresy, k nacteni nahledu obrazku
    final String PREVIEW_ADDRESS_PARAMS = "&amp;SDS=0.90&amp;CNT=1.0&amp;WID=243&amp;QLT=99&amp;CVT=jpeg";
    // pocet obrazku na jednom radku vypisu
    final int SLIDES_PER_ROW = 5;
    // priklad spravneho pojmenovani Rok(4x 0-9)_BioptickeCislo(4-6x 0-9)-OznaceniSkla(2x 0-9)-Typ(T/N/M).jp2
    final String FILE_NAME_SAMPLE = "2009_2667-04-T.jp2";
    // jsp stranka s detailem
    final String DETAIL = "detail.html?path=";


    // nacti parametr z URL ve formatu Rok_BioptickeCislo
    String biopsyParam = request.getParameter(BIOPSY_PARAM_NAME);

    Integer year = null;
    Integer biopticalNumber = null;

    // Problem with file name validity - signalizuje, ze v prubehu zpracovani doslo k problemu s pojmenovanim souboru neodpovidajicim predpokladane strukture
    boolean prblmWthFlNmVldty = false;

    // zacatek odstavce chyb
    out.print("<p>");

    if (biopsyParam == null) {
        // set 404 status
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        // message to user
        out.println("No param to identify biopsy");
    } else {

        // minimalni velikost 4 + podtrzitko
        if (biopsyParam.length() > 5) {
            // prvni 4 znaky jsou rok
            String parsedYear = null;

            try {
                parsedYear = biopsyParam.substring(0, 4);
            } catch (java.lang.IndexOutOfBoundsException ex) {
                out.println("Unable to parse year from param: " + biopsyParam);
                parsedYear = null;
            }

            // nasledujici znaky jsou biopticke cislo. Sesty az posledni znak, protoze rok a biopticke cislo je oddeleno podtrzitkem
            String parsedBiopticalNumber = null;
            try {
                parsedBiopticalNumber = biopsyParam.substring(5);
            } catch (java.lang.IndexOutOfBoundsException ex) {
                // invalid file name
                out.println("Unable to parse bioptical number from param: " + biopsyParam);
                parsedBiopticalNumber = null;
            }

            if (parsedYear != null && parsedBiopticalNumber != null) {
                // kontrola zda rok a biopticke cislo jsou ciselne hodnoty
                try {
                    year = Integer.parseInt(parsedYear);
                    biopticalNumber = Integer.parseInt(parsedBiopticalNumber);
                } catch (NumberFormatException ex) {
                    year = null;
                    biopticalNumber = null;

                    // set 404 status
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    // message to user
                    out.println("Not a valid year or biopsy id. Please contact it-recamo@mou.cz if this biopsy should be present.");
                }
            }
        }
    }

    if (year == null || biopticalNumber == null) {
        // set 404 status
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        // message to user
        out.println("Not a valid year or biopsy id. Please contact it-recamo@mou.cz if this biopsy should be present.");
    }

    if (year != null && biopticalNumber != null) {

        String folderPath = SLIDES_REPOSITORY;
        final File folder = new File(folderPath);
        boolean folderExists = folder.isDirectory();

        if (!folderExists) {
            // set 404 status
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.println("Directory doesn't exist! Please contact it-recamo@mou.cz if this directory should be present.");
        }

        if (folderExists) {
            // nacti vsechny soubory ve slozce
            File[] listOfAllFiles = folder.listFiles();

            // seznam souboru souvisejici se zadanou biopsii
            List<String> listOfRelevantFiles = new ArrayList<String>();
            for (int i = 0; i < listOfAllFiles.length; i++) {
                String name = listOfAllFiles[i].getName();
                String suffix = null;


                try {
                    suffix = name.substring(name.length() - SUFFIX_JP_2000.length());
                } catch (java.lang.IndexOutOfBoundsException ex) {
                    // neplatne jmeno souboru
                    out.println(name);
                    // informovat uzivatele
                    prblmWthFlNmVldty = true;
                    suffix = "";
                }

                // nacist rok z jmena souboru
                int fileYear = 0;

                try {
                    // vybrat cast nazvu souboru ktera odpovida roku
                    String temp = name.substring(0, 4);
                    // preved string na cislo
                    fileYear = Integer.parseInt(temp);
                    // nebylo mozno udelat substring
                } catch (java.lang.IndexOutOfBoundsException ex) {
                    // neplatne jmeno souboru
                    out.println(name);
                    // informovat uzivatele
                    prblmWthFlNmVldty = true;
                    // nebylo mozno prevezt cislo
                } catch (NumberFormatException ex) {
                    out.println("Unable to parse year from: " + name);
                }

                // pokud soubor neobsahuje - tak je nevalidni -> pojmenovani souboru ma jasne predepsanou strukturu
                if (name.indexOf('-') < 0) {
                    // invalid file name
                    out.println(name);
                    // informovat uzivatele
                    prblmWthFlNmVldty = true;
                    continue;
                }

                // nacist cislo biopsie z jmena souboru
                int fileBiopticalNumber = 0;

                try {
                    // vybrat cast nazvu souboru ktera odpovida bioptickemu cislu
                    String temp = name.substring(5, name.indexOf('-'));
                    // preved string na cislo
                    fileBiopticalNumber = Integer.parseInt(temp);
                    // nebylo mozno udelat substring
                } catch (java.lang.IndexOutOfBoundsException ex) {
                    // invalid file name
                    out.println(name);
                    // informovat uzivatele
                    prblmWthFlNmVldty = true;
                    // nebylo mozno prevezt cislo
                } catch (NumberFormatException ex) {
                    out.println("Unable to parse bioptical number from: " + name);
                }

                // pokud je soubor jp2 a shoduje se rok a cislo biopsie tak ho pridej do seznamu
                if (suffix.equals(SUFFIX_JP_2000) && fileYear == year && fileBiopticalNumber == biopticalNumber) {
                    listOfRelevantFiles.add(name);
                }
            }

            // konec odstavce chyb
            out.print("</p>");

            // vypsat alert hlasku pro uzivatele
            if (prblmWthFlNmVldty) {
                // vypsat nadpis
                out.print("<div class=\"alert alert-danger\">");
                out.print("<b>");
                out.print("Pojmenovani nekterych souboru pravdepodobne nesplnuje pozadovanou strukturu:");
                out.print("</b>");
                out.print("<ul>");
                out.print("<li>");
                out.print("<b>Priklad spravneho pojmenovani je:</b> " + FILE_NAME_SAMPLE);
                out.print("</li>");
                out.print("<li>");
                out.print("<b>Vzorec pojmenovani:</b> rok(4x 0-9) _ biopticke cislo(4-6x 0-9) - oznaceni skla(2x 0-9) - typ(T/N/M).jp2");
                out.print("</li>");
                out.print("<li>");
                out.print("Je nezbytne dodrzet pozice podtrzitek, pomlcek a tecky. Pri poruseni teto struktury neni soubor zpracovan. Prosime o napravu nazvu vyse uvedenych souboru.");
                out.print("</li>");
                out.print("</ul>");
                out.print("</div>");

            }

            // vypsat nadpis
            out.print("<h2> Case: Biopsy " + biopsyParam + "</h2>");

            if (!listOfRelevantFiles.isEmpty()) {
                // tabulka obalujici vypis obrazku
                out.print("<table border=\"0\"><tbody>");
                // iteruj pres vsechny soubory
                for (int i = 0; i < listOfRelevantFiles.size(); ) {
                    // na jednom radku zobraz n zaznamu
                    out.print("<tr>");
                    for (int j = 0; j < SLIDES_PER_ROW; j++) {

                        out.print("<td>");

                        if (i + j <= listOfRelevantFiles.size() - 1) {
                            // jmeno souboru - format priblizne 2015_06353-01-T.jp2
                            String name = listOfRelevantFiles.get(i + j);
                            // z jmena souboru vytahni priponu
                            String suffix = name.substring(name.length() - SUFFIX_JP_2000.length());
                            // z jmena souboru vytahni posledni pismeno, definujici typ biopsie
                            char type = name.charAt(name.length() - 1 - SUFFIX_JP_2000.length());

                            // kontrola zda je jedna o .jp2 obrazek
                            if (suffix.equals(SUFFIX_JP_2000)) {
                                // adresa pro iipimage zobrazovac
                                String viewerAddress = DETAIL + "" + name;
                               // odkaz na obrazek
                                out.print("<a href=\"");

                                out.print(viewerAddress);

                                out.print("\">");

                                // nahled obrazku, vyuzivajici skript iipimage
                                out.print("<img style=\"border: 1px solid black;;\" border=\"0\" width=\"150\" height=\"150\" alt=\"\" src=\"");
                                out.print(PREVIEW_ADDRESS);
                                out.print("/" + name);
                                out.print(PREVIEW_ADDRESS_PARAMS);
                                out.print("\">");

                                out.print("</a>");

                                out.print("<br>");

                                // vypis typu biopsie dle posledniho pismena
                                switch (type) {
                                    case 'T':
                                        out.print("<b>Tumor</b>");
                                        break;
                                    case 'M':
                                        out.print("<b>Metastasis</b>");
                                        break;
                                    case 'N':
                                        out.print("<b>Non-tumor</b>");
                                        break;
				    case 'C':
                                        out.print("<b>Collection</b>");
                                        break;

                                }

                                out.print("<br>");

                                out.print("<a href=\"");
                                out.print(viewerAddress);
								out.print("\">");
                                out.print(name);
                                out.print("</a>");

                            }
                        }

                        out.print("</td>");

                    }
                    out.print("</tr>");

                    i += SLIDES_PER_ROW;

                    // oddelovac radku pokud je vice biopsii nez 4
                    if (i < listOfRelevantFiles.size()) {
                        out.print(" <tr> <td colspan=\"" + SLIDES_PER_ROW + "\" style=\"border: none; height: 20px;\">&nbsp;</td></tr>");
                    }

                }

                out.print("</tbody></table>");
            }

            if (listOfRelevantFiles.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.println("There are no images for the biopsy");
            }
        }
    }

%>
