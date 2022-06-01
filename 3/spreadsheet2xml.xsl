<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0">
    <xsl:output version="1.0" encoding="UTF-8" method="xml" indent="yes" media-type="text/xml" />

    <xsl:template match="/">
        <casualties>
            <xsl:for-each select="//office:body/office:spreadsheet/table:table/table:table-row[position()>1][table:table-cell[1]/@office:value-type='string']">

                <a>
                    <xsl:attribute name="date"><xsl:value-of select="translate(table:table-cell[1]/text:p, '.', '-')" /></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="table:table-cell[2][@table:number-columns-repeated = '2']">
                            <xsl:attribute name="country"><xsl:value-of select="table:table-cell[2]/text:p" /></xsl:attribute>
                            <xsl:attribute name="city"><xsl:value-of select="table:table-cell[2]/text:p" /></xsl:attribute>
                            <xsl:attribute name="killed"><xsl:value-of select="table:table-cell[3]/text:p" /></xsl:attribute>
                            <xsl:attribute name="injured"><xsl:value-of select="table:table-cell[4]/text:p" /></xsl:attribute>
                            <xsl:attribute name="description"><xsl:value-of select="table:table-cell[5]/text:p" /></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="country"><xsl:value-of select="table:table-cell[2]/text:p" /></xsl:attribute>
                            <xsl:attribute name="city"><xsl:value-of select="table:table-cell[3]/text:p" /></xsl:attribute>
                            <xsl:attribute name="killed"><xsl:value-of select="table:table-cell[4]/text:p" /></xsl:attribute>
                            <xsl:attribute name="injured"><xsl:value-of select="table:table-cell[5]/text:p" /></xsl:attribute>
                            <xsl:attribute name="description"><xsl:value-of select="table:table-cell[6]/text:p" /></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <!-- <attack date="" injured="0" killed="2" city="Bachan" country="Israel" /> -->
            </xsl:for-each>
        </casualties>
    </xsl:template>

</xsl:stylesheet>