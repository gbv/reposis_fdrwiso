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
        
        <xsl:if test="$period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='start']">
          <xsl:variable name="formatStartDate">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='start']))=4">
                <xsl:value-of select="i18n:translate('metaData.dateYear')" />
              </xsl:when>
              <xsl:when test="string-length(normalize-space($period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='start']))=7">
                <xsl:value-of select="i18n:translate('metaData.dateYearMonth')" />
              </xsl:when>
              <xsl:when test="string-length(normalize-space($period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='start']))=10">
                <xsl:value-of select="i18n:translate('metaData.dateYearMonthDay')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="i18n:translate('metaData.dateTime')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="startDate">
            <xsl:call-template name="formatISODate">
              <xsl:with-param name="date" select="$period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='start']" />
              <xsl:with-param name="format" select="$formatStartDate" />
            </xsl:call-template>
          </xsl:variable>
        </xsl:if>

        <xsl:if test="$period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end']">
          <xsl:variable name="formatEndDate">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end']))=4">
                <xsl:value-of select="i18n:translate('metaData.dateYear')" />
              </xsl:when>
              <xsl:when test="string-length(normalize-space($period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end']))=7">
                <xsl:value-of select="i18n:translate('metaData.dateYearMonth')" />
              </xsl:when>
              <xsl:when test="string-length(normalize-space($period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end']))=10">
                <xsl:value-of select="i18n:translate('metaData.dateYearMonthDay')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="i18n:translate('metaData.dateTime')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="endDate">
            <xsl:call-template name="formatISODate">
              <xsl:with-param name="date" select="$period_of_reference/mods:temporal[@encoding='w3cdtf'][@point='end']" />
              <xsl:with-param name="format" select="$formatEndDate" />
            </xsl:call-template>
          </xsl:variable>
        </xsl:if>

        <div id="fdrwiso-metadata">
          <div class="mir_metadata">
            <dl>
              <dt><xsl:value-of select="concat(i18n:translate('component.mods.metaData.dictionary.period'), ': ')" /></dt>
              <dd>
                <xsl:if test="$startDate">
                  <xsl:value-of select="$startDate" />
                </xsl:if>
                <xsl:if test="$endDate">
                  <xsl:value-of select="concat(' - ', $endDate)" />
                </xsl:if>
              </dd>
            </dl>
          </div>
        </div>
      </xsl:if>
      <xsl:apply-imports/>
    </xsl:template>

</xsl:stylesheet>