<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:mir="http://www.mycore.de/mir"
  exclude-result-prefixes="mods mir">

  <xsl:import href="xslImport:solr-document:fdrwiso-solr.xsl" />

  <xsl:template match="mycoreobject[contains(@ID,'_mods_')]">
    <xsl:apply-templates select="metadata/def.modsContainer/modsContainer/mods:mods" mode="fdrwiso" />
    <xsl:apply-imports />
  </xsl:template>

  <xsl:template match="mods:mods" mode="fdrwiso">
    <xsl:apply-templates select="mods:extension[@type='temporal_period_of_reference']/mir:subject[@type='period_of_reference']" mode="fdrwiso" />
  </xsl:template>

  <xsl:template match="mir:subject[@type='period_of_reference']" mode="fdrwiso">
    <field name="fdrwiso.mods.period_of_reference">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="mods:temporal[@encoding='w3cdtf' and @point='start']/text()" />
      <xsl:text> TO </xsl:text>
      <xsl:value-of select="mods:temporal[@encoding='w3cdtf' and @point='end']/text()" />
      <xsl:text>]</xsl:text>
    </field>
  </xsl:template>

</xsl:stylesheet>
