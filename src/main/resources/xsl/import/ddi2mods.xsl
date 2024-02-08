<?xml version="1.0" encoding="UTF-8"?>

<!-- xmlns:ddi="ddi:instance:3_1  http://www.ddialliance.org/Specification/DDI-Lifecycle/3.1/XMLSchema/instance.xsd" -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xalan="http://xml.apache.org/xalan"
    exclude-result-prefixes="xsl xsi xalan">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2" />
    
    <xsl:template match="DDIInstance">
        <mods:mods>
            <xsl:apply-templates select="StudyUnit/Citation/Title" />
            <xsl:apply-templates select="StudyUnit/Citation/Creator" />
            <xsl:apply-templates select="StudyUnit/Citation/InternationalIdentifier" />
            <mods:originInfo eventType="publication">
                <xsl:apply-templates select="StudyUnit/Citation/Publisher" />
            </mods:originInfo>
            <xsl:apply-templates select="language" />
            <xsl:apply-templates select="subjects/subject" />
            <xsl:apply-templates select="StudyUnit/Abstract/Content" />
        </mods:mods>
    </xsl:template>
    
    <xsl:template match="Title">
        <mods:titleInfo>
            <mods:title>
                <xsl:value-of select="text()" />
            </mods:title>
        </mods:titleInfo>
    </xsl:template>
    
    <xsl:template match="Creator[contains(text(),',')]">
        <mods:name type="personal">
            <xsl:call-template name="creatorName">
                <xsl:with-param name="name" select="text()" />
            </xsl:call-template>
            <mods:role>
                <mods:roleTerm authority="marcrelator" type="code">aut</mods:roleTerm>
            </mods:role>
        </mods:name>
    </xsl:template>
    
    <xsl:template name="creatorName">
        <xsl:param name="name" />
        <mods:namePart type="family">
            <xsl:value-of select="normalize-space(substring-before($name,','))" />
        </mods:namePart>
        <mods:namePart type="given">
            <xsl:value-of select="normalize-space(substring-after($name,','))" />
        </mods:namePart>
    </xsl:template>
    
    <xsl:template match="Publisher">
        <mods:publisher>
            <xsl:value-of select="text()" />
        </mods:publisher>
    </xsl:template>
    
    <xsl:template match="publicationYear">
        <mods:dateIssued encoding="w3cdtf">
            <xsl:value-of select="text()" />
        </mods:dateIssued>
    </xsl:template>
    
    <xsl:template match="language">
        <xsl:for-each select="document(concat('notnull:language:',.))/language/@xmlCode">
            <mods:language>
                <mods:languageTerm authority="rfc5646" type="code">
                    <xsl:value-of select="." />
                </mods:languageTerm>
            </mods:language>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="subject">
        <mods:subject>
            <mods:topic>
                <xsl:value-of select="text()" />
            </mods:topic>
        </mods:subject>
    </xsl:template>
    
    <xsl:template match="Content">
        <mods:abstract>
            <xsl:value-of select="text()" />
        </mods:abstract>
    </xsl:template>
    
    <xsl:template match="InternationalIdentifier">
        <mods:identifier type="doi">
            <xsl:choose>
                <xsl:when test="contains(text(), 'doi:')"><xsl:value-of select="substring-after(text(), 'doi:')" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="text()" /></xsl:otherwise>
            </xsl:choose>
        </mods:identifier>
    </xsl:template>
    <xsl:template match="@*|*" />
    
</xsl:stylesheet>
