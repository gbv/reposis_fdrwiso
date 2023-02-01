<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:mir="http://www.mycore.de/mir"
                version="1.0"
                exclude-result-prefixes="i18n mods mir xlink"
>

    <xsl:import href="xslImport:modsmeta:metadata/fdrwiso-metadata.xsl"/>
    <xsl:variable name="objectID" select="/mycoreobject/@ID"/>

    <xsl:template match="/">
      <xsl:variable name="mods" select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" />
      
      <xsl:if test="$mods/mods:extension[@type='temporal_period_of_reference']/mir:subject[@type='period_of_reference']">
        <xsl:variable name="period_of_reference" select="$mods/mods:extension[@type='temporal_period_of_reference']/mir:subject[@type='period_of_reference']" />
        <div id="fdrwiso-metadata" class="mir_metadata">
          <dl>
            <dt><xsl:value-of select="concat(i18n:translate('component.mods.metaData.dictionary.period'), ': ')" /></dt>
            <dd>
              <xsl:value-of select="$period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='start']" />
              <xsl:if test="$period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end']">
                <xsl:value-of select="concat(' - ', $period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end'])" />
              </xsl:if>
            </dd>
          </dl>
        </div>
      </xsl:if>
      <xsl:apply-imports/>
    </xsl:template>

</xsl:stylesheet>