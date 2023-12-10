<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ddi="ddi:codebook:2_5"
    xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="mods"
    version="3.0">


    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <ddi:codeBook version="2.5" xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd">
            <ddi:docDscr>
                <ddi:citation>
                    <ddi:titlStmt>
                        <ddi:titl xml:lang="en">
                            <xsl:value-of select="//mods:title" />
                        </ddi:titl>
                    </ddi:titlStmt>
                </ddi:citation>
            </ddi:docDscr>
            <ddi:stdyDscr>
                <ddi:citation>
                    <ddi:titlStmt>
                        <ddi:titl xml:lang="en" >
                            <xsl:value-of select="//mods:title" />
                        </ddi:titl> 
                    </ddi:titlStmt>
                </ddi:citation>
                <ddi:stdyInfo>
                    <ddi:subject>
                        <xsl:variable name="jel">
                            <xsl:value-of select="substring-after(//mods:classification[@displayLabel='jel']/@valueURI, '#')" />
                        </xsl:variable>
                        <ddi:keyword xml:lang="en" vocab="JEL" vocabURI="https://emporion.gswg.info/api/v2/classifications/jel" ID="{$jel}" ><xsl:value-of select="$jel"/></ddi:keyword>
                    </ddi:subject>
                    <ddi:abstract xml:lang="en" >
                        <xsl:value-of select="//mods:abstract" />
                    </ddi:abstract>
                </ddi:stdyInfo>
            </ddi:stdyDscr>
            <ddi:fileDscr>
                <ddi:fileTxt>
                    <ddi:fileName xml:lang="en" ><xsl:value-of select="//maindoc" /></ddi:fileName>
                </ddi:fileTxt>
            </ddi:fileDscr> 
        </ddi:codeBook>
    </xsl:template>
</xsl:stylesheet>