<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output
        method="xml"
        encoding="UTF-8"
        indent="yes"
        media-type="text/xml"
        omit-xml-declaration="yes"
        />
    <xsl:variable name="width" select="814" />
 
    <xsl:template match="/">
        <svg width="{$width}" height="60" xmlns="http://www.w3.org/2000/svg">
            <xsl:variable name="font_size" select="14" />
            <xsl:variable name="heightPerRow" select="$font_size * 3.5" />

            <xsl:attribute name="height">
                <xsl:value-of select="(count(/casualties/a) + 2) * $heightPerRow"/>
            </xsl:attribute>

            <style><![CDATA[
            x {
                height: 1rem;
                line-height: 1rem;
                background-color: red;
                display: inline-block;
                font-size: .75rem;
                font-family: monospace;
                min-width: 1rem;
                text-align: center;
                color: white;
            }
            z {
                height: 1rem;
                line-height: 1rem;
                background-color: orange;
                display: inline-block;
                font-size: .75rem;
                font-family: monospace;
                min-width: 1rem;
                text-align: center;
                color: white;
            }
            text{
                dominant-baseline: hanging;
            }
            p, foreignObject {
                margin: 0;
                overflow: scroll;
                font: ]]><xsl:value-of select="$font_size" /><![CDATA[px Verdana, Helvetica, Arial, sans-serif;
            }
            ]]></style> 
            
            <path stroke="black" fill="transparent" stroke-linecap="round" stroke-width="1">
                <xsl:attribute name="d">
                    <xsl:text>M </xsl:text><xsl:value-of select="$width div 2" /><xsl:text>,10</xsl:text>
                    <xsl:text> l 0, </xsl:text><xsl:value-of select="count(/casualties/a) * $heightPerRow"/>
                    <xsl:text> Z</xsl:text>
                </xsl:attribute>
            </path>
            
            <xsl:for-each select="/casualties/a">
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">
                        <path stroke="black" fill="transparent" stroke-linecap="round" stroke-width="1">
                            <xsl:attribute name="d">
                                <xsl:text>M </xsl:text><xsl:value-of select="$width div 2" />,<xsl:value-of select="position() * $heightPerRow" /><xsl:text></xsl:text>
                                <xsl:text> l -</xsl:text><xsl:text>20, 0</xsl:text>
                            </xsl:attribute>
                        </path>
                        <foreignObject>
                            <xsl:attribute name="width"><xsl:value-of select="$width div 2 - 40" /></xsl:attribute>
                            <xsl:attribute name="height"><xsl:value-of select="$heightPerRow" /></xsl:attribute>
                            <xsl:attribute name="x">20</xsl:attribute>
                            <xsl:attribute name="y"><xsl:value-of select="position() * $heightPerRow - (2 * $font_size)" /></xsl:attribute>
                            <p xmlns="http://www.w3.org/1999/xhtml">
                                <xsl:call-template name="desc" />
                            </p>
                        </foreignObject>
                    </xsl:when>
                    <xsl:otherwise>
                        <path stroke="black" fill="transparent" stroke-linecap="round" stroke-width="1">
                            <xsl:attribute name="d">
                                <xsl:text>M </xsl:text><xsl:value-of select="$width div 2" />,<xsl:value-of select="position() * $heightPerRow" /><xsl:text></xsl:text>
                                <xsl:text> l </xsl:text><xsl:text>20, 0</xsl:text>
                            </xsl:attribute>
                        </path>
                        <foreignObject>
                            <xsl:attribute name="width"><xsl:value-of select="$width div 2 - 40" /></xsl:attribute>
                            <xsl:attribute name="height"><xsl:value-of select="$heightPerRow" /></xsl:attribute>
                            <xsl:attribute name="x"><xsl:value-of select="$width div 2 + 30" /></xsl:attribute>
                            <xsl:attribute name="y"><xsl:value-of select="position() * $heightPerRow - (2 * $font_size)" /></xsl:attribute>
                            <p xmlns="http://www.w3.org/1999/xhtml">
                                <xsl:call-template name="desc" />
                            </p>
                        </foreignObject>
                    </xsl:otherwise>

                </xsl:choose>
            </xsl:for-each>
        </svg>

    </xsl:template>

<!-- <text x="10" y="10">Hello World!</text> -->

    <xsl:template name="desc">
        <xsl:value-of select="@date" /> - <z><xsl:value-of select="@injured" /></z> <x><xsl:value-of select="@killed" /></x> - <xsl:value-of select="@country" /> - <xsl:value-of select="@city" /> - <xsl:value-of select="@description" />
    </xsl:template>

</xsl:stylesheet>