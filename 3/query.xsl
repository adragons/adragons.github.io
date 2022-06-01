<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output
        method="xml"
        encoding="UTF-8"
        indent="yes"
        media-type="text/xml"
        />

    <xsl:variable name="attacks" select="/casualties" />

    <xsl:param name="sort" select="'descending'" />
    <xsl:param name="country" />

    <xsl:template match="/">
        <casualties>
            <xsl:attribute name="injured"><xsl:value-of select="sum(/casualties/a[contains($country,@country)]/@injured)" /></xsl:attribute>
            <xsl:attribute name="killed"><xsl:value-of select="sum(/casualties/a[contains($country,@country)]/@killed)" /></xsl:attribute>
            <xsl:for-each select="/casualties/a[contains($country,@country)]">
                <xsl:sort select="@date" order="{$sort}" />
                <xsl:copy-of select="." />
            </xsl:for-each>
        </casualties>
    </xsl:template>

</xsl:stylesheet>