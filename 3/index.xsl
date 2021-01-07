<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes" media-type="text/html" />
<xsl:template match="/">
    <html>
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <title>Islamic labours</title>
        <link rel="stylesheet" type="text/css" href="css.css" />
        <style type="text/css">
            x {
                height: 1rem;
                background-color: red;
                display: inline-block;
                font-size: 0;
            }
            z {
                height: 1rem;
                background-color: orange;
                display: inline-block;
                font-size: 0;
            }
            table td:first-child {
                display: none;
            }
            table td {
                white-space: pre;
            }
            table {
                line-height: 14px;
            }
            table * {
                line-height: 14px;
                height: 14px;
            }
            #date-indicator {
                position: fixed;
                top: calc(50% - 1ch);
                left: 0;
                margin-left: calc(50% - 40ch - 12ch);
                width: 12ch;
                line-height: 1rem;
            }
            #date-indicator span {
                float: right;
            }
            #pixel {
                display: none;
                background-color: pink;
                height: 1px;
                width: 1px;
                font-size: 0;
                position: fixed;
            }
            #buttons {
                position: fixed;
                top: calc(50% - 2rem);
                left: 0;
                margin-left: calc(50% - 40ch - 12ch - 12ch);
                width: 12ch;
                line-height: 1rem;
            }
            #buttons button {
                font-size: 2rem;
            }
        </style>
    </head>
    <body>
        <content class="" style="margin:0 auto; max-width:80ch;">
            <div style="height: 100vh">
                <p><a href="../index.html">&lt; Index</a></p>
                <h1>Islamic labours</h1>


                <p>Terrorist attacks in the name of Allah are so common that displaying
                them clearly in a graph or chart is difficult.</p>

                <note>Source: https://thereligionofpeace.com/</note>
                <p><x style="width:1rem;"></x> Killed</p>
                <p><z style="width:1rem;"></z> Injured</p>
                <p>Each casualty is 3 pixels wide. Use arrow on keyboard or arrow buttons for accurate scrolling.</p>
                <br /><br />
                <center style="font-size: 2rem;">&#x2193;</center>
            </div>
            <table>
            
                <xsl:apply-templates/>
            </table>

            <div style="height: 100vh">
            </div>


        </content>

        <div id="date-indicator">
        
        </div>
        <div id="buttons">
            <button onclick="scrollUp()">&#x2191;</button><br />
            <button onclick="scrollDown()">&#x2193;</button>
        </div>
        <script>
        let arrow = '&#x2192;';
            window.addEventListener('scroll', function(e){
                let tdRect = document
                    .querySelector("table tr:first-child td:nth-child(2)")
                    .getBoundingClientRect();
                let tdX = tdRect.left + 1;

                let dateIndicator = document.querySelector("#date-indicator");
                let rect = dateIndicator.getBoundingClientRect();
                let height = rect.bottom - rect.top;
                let top = rect.top + (tdRect.bottom - tdRect.top)/2;

                document.querySelector('#pixel').style.left = 1+tdX + 'px';
                document.querySelector('#pixel').style.top = top + 'px';

                let x = document.elementFromPoint(tdX, top)
                if (x.nodeName === "DIV") {
                    document.querySelector('#date-indicator').innerHTML = '';
                    return;
                }

                let td = x;
                if (x.nodeName !== "TD") {
                    td = x.parentElement;
                }
                let tr = td.parentElement;
                let date = tr.querySelector('td:first-child').innerHTML;

                let kills = +tr.querySelector('x').innerHTML;
                let injured = +tr.querySelector('z').innerHTML;
                
                document.querySelector('#date-indicator').innerHTML = `
                    ${date} &lt;span&gt;&#x2192;&lt;/span&gt;<br />
                    Deaths: ${kills}<br />
                    Injured: ${injured}
                    `;

            });
            function scrollUp() {
                window.scrollTo(0, window.scrollY - 14);
            }
            function scrollDown() {
                window.scrollTo(0, window.scrollY + 14);
            }
            window.addEventListener('keydown', function(e){
                if (e.key === "ArrowUp" || e.keyCode === 38) {
                    e.preventDefault();
                    e.stopPropagation();
                    scrollUp();
                } else 
                if (e.key === "ArrowDown" || e.keyCode === 40) {
                    e.preventDefault();
                    e.stopPropagation();
                    scrollDown();
                }
            })
        </script>
        <div id="pixel"></div>
    </body>
    </html>
</xsl:template>
<xsl:template match="attack">
    <xsl:param name="killed" select="@killed" />
    <xsl:param name="injured" select="@injured" />
    <tr>
        <td><xsl:value-of select="@date" /></td>
        <td><x style="width:calc({$killed}px * 3);"><xsl:value-of select="$killed" /></x><z style="width:calc({$injured}px * 3);"><xsl:value-of select="$injured" /></z></td>
    </tr>
</xsl:template>
</xsl:stylesheet>