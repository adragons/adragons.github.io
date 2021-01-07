<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes" media-type="text/html" />
<xsl:variable name="countries" select="document('countries.xml')" />
<xsl:template match="/">
    <html>
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <title>Islamic labours</title>
        <link rel="stylesheet" type="text/css" href="../css.css" />
        <style type="text/css">
            x {
                height: 1rem;
                line-height: 1rem;
                background-color: red;
                display: inline-block;
                font-size: .75rem;
                font-family: monospace;
            }
            z {
                height: 1rem;
                line-height: 1rem;
                background-color: orange;
                display: inline-block;
                font-size: .75rem;
                font-family: monospace;
            }
            table td {
                white-space: pre;
                font-size: 1rem;
            }
            table {
                border-spacing: 5px;
                border-collapse: separate;
                line-height: 14px;
            }
            th {
                text-align: left;
            }
            #pixel {
                display: none;
                background-color: pink;
                height: 1px;
                width: 1px;
                font-size: 0;
                position: fixed;
            }
        </style>
    </head>
    <body>
        <content class="" style="margin:0 auto; max-width:80ch;">
            <p><a href="../index.html">&lt; Index</a></p>
            <h1>Islamic labours</h1>


            <p>Terrorist attacks in the name of Allah are so common that displaying
            them clearly in a graph or chart is difficult.</p>

            <note>Source: https://thereligionofpeace.com/</note>
            <p><x style="width:1rem;"></x> Killed</p>
            <p><z style="width:1rem;"></z> Injured</p>
            <br /><br />
            <table>
                <tr>
                    <th>Date</th>
                    <th colspan="2">Location</th>
                    <th colspan="2">Death / Injuries</th>
                </tr>
                <xsl:apply-templates/>
                <tr>
                    <th></th>
                    <th colspan="2"></th>
                    <th colspan="2">Total</th>
                </tr>
                <tr>
                    <th></th>
                    <th colspan="2"></th>
                    <th colspan="2"><xsl:value-of select="sum(//attack/@killed)" /> / <xsl:value-of select="sum(//attack/@injured)" /></th>
                </tr>
            </table>
            <br />
            <br />
        </content>
        <div id="pixel"></div>
    </body>
    </html>
</xsl:template>
<xsl:template match="attack">
    <xsl:param name="killed" select="@killed" />
    <xsl:param name="injured" select="@injured" />
    <xsl:param name="country" select="@country" />
    <xsl:param name="city" select="@city" />
    <tr>
        <td><xsl:value-of select="@date" /></td>
        <td title="{$country}"><xsl:value-of select="document($countries)/countries/country[@name=$country]/@flag" /></td>
        <td><xsl:value-of select="$city" /></td>
        <td><xsl:value-of select="$killed" /> / <xsl:value-of select="$injured" /></td>
        <td><x style="width:{$killed}px;"></x><z style="width:{$injured}px;"></z></td>
    </tr>
</xsl:template>
</xsl:stylesheet>