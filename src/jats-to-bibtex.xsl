<?xml version="1.0" encoding="UTF-8"?>
<stylesheet version="1.0"
            xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- documentation: http://www.refman.com/support/risformat_intro.asp -->
    <output method="text" encoding="utf-8"/>

    <template match="/">
        <apply-templates select="article/front/article-meta"/>
    </template>

    <template match="article-meta">
        <text>@article {</text>
        <text>&#10;</text><!-- newline -->
        <apply-templates select="contrib-group[not(@contrib-group)][1]"/>
        <apply-templates select="contrib-group[not(@contrib-group)][2]"/>
        <apply-templates select="title-group/article-title"/>
        <apply-templates select="volume"/>
        <apply-templates select="pub-date[@date-type='pub']/year"/>
        <apply-templates select="article-id[@pub-id-type='doi']"/>
        <apply-templates select="../journal-meta/publisher/publisher-name"/>
        <apply-templates select="abstract[not(@abstract-type)]"/>
        <apply-templates select="../journal-meta/issn"/>
        <apply-templates select="../journal-meta/journal-title-group/journal-title"/>
        <call-template name="item">
            <with-param name="key">article_type</with-param>
            <with-param name="value">journal</with-param>
            <with-param name="suffix" select="','"/>
        </call-template>
        <apply-templates select="pub-date[@date-type='pub']"/>
        <call-template name="item">
            <with-param name="key">URL</with-param>
            <with-param name="value" select="concat('http://elifesciences.org/content/', volume, '/', elocation-id)"/>
            <with-param name="suffix" select="','"/>
        </call-template>
        <call-template name="item">
            <with-param name="key">citation</with-param>
            <with-param name="value" select="concat(../journal-meta/journal-title-group/journal-title, ' ', pub-date[@date-type='pub']/year, ';', volume, ':', elocation-id)"/>
            <with-param name="suffix" select="''"/>
        </call-template><!-- always at the end, to avoid trailing comma -->
        <text>}</text>
        <text>&#10;</text><!-- newline -->
    </template>

    <template name="item">
        <param name="key"/>
        <param name="value"/>
        <param name="suffix" select="','"/>
        <value-of select="concat('&#x9;', $key, ' = {', $value, '}', $suffix, '&#10;')"/>
    </template>

    <template match="article-id[@pub-id-type='doi']">
        <call-template name="item">
            <with-param name="key">doi</with-param>
            <with-param name="value" select="."/>
        </call-template>
    </template>

	<template match="article-title">
        <call-template name="item">
            <with-param name="key">title</with-param>
            <with-param name="value">
                <apply-templates mode="markup"/>
            </with-param>
        </call-template>
    </template>

    <template match="contrib-group[not(@contrib-group)][1]">
        <call-template name="item">
            <with-param name="key">author</with-param>
            <with-param name="value">
                <apply-templates select="contrib[@contrib-type='author']"/>
            </with-param>
        </call-template>
    </template>

    <template match="contrib-group[not(@contrib-group)][2]">
        <call-template name="item">
            <with-param name="key">editor</with-param>
            <with-param name="value">
                <apply-templates select="contrib[@contrib-type='editor']"/>
            </with-param>
        </call-template>
    </template>

    <!-- contributors (authors and editors) -->
	<template match="contrib">
        <choose>
            <when test="name">
                <value-of select="name/surname"/>
                <apply-templates select="name/suffix" mode="name"/>
                <apply-templates select="name/given-names" mode="name"/>
            </when>
        </choose>

        <if test="position() != last()">
            <value-of select="' and '"/>
        </if>
	</template>

    <template match="given-names | suffix" mode="name">
        <value-of select="concat(', ', .)"/>
    </template>

    <template match="kwd-group[@kwd-group-type='author']">
        <call-template name="item">
            <with-param name="key">keywords</with-param>
            <with-param name="value">
                <apply-templates select="kwd"/>
            </with-param>
        </call-template>
    </template>

    <template match="kwd">
        <value-of select="."/>

        <if test="position() != last()">
            <value-of select="', '"/>
        </if>
    </template>

    <template match="pub-date[@date-type='pub']">
        <call-template name="item">
            <with-param name="key">pub_date</with-param>
            <with-param name="value" select="concat(year, '-', month, '-', day)"/>
        </call-template>
    </template>

    <template match="pub-date[@date-type='pub']/year">
        <call-template name="item">
            <with-param name="key">year</with-param>
            <with-param name="value"><value-of select="."/></with-param>
        </call-template>
    </template>

    <template match="year | month | volume">
        <call-template name="item">
            <with-param name="key" select="local-name()"/>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <template match="abstract">
        <variable name="text" select="."/>

        <variable name="newtext1">
            <call-template name="string-replace-all">
                <with-param name="text" select="$text"/>
                <with-param name="replace" select="object-id[@pub-id-type='doi']"/>
                <with-param name="by" select="''"/>
            </call-template>
        </variable>

        <variable name="newtext2">
        <call-template name="string-replace-all">
            <with-param name="text" select="$newtext1"/>
            <with-param name="replace" select="'DOI: http://dx.doi.org/'"/>
            <with-param name="by" select="''"/>
        </call-template>
        </variable>

        <call-template name="item">
            <with-param name="key">abstract</with-param>
            <with-param name="value" select="$newtext2"/>
        </call-template>
    </template>

    <template match="elocation-id">
        <call-template name="item">
            <with-param name="key">pages</with-param>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <template match="publisher-name">
        <call-template name="item">
            <with-param name="key">publisher</with-param>
            <with-param name="value"><value-of select="."/></with-param>
        </call-template>
    </template>

    <template match="journal-title">
        <call-template name="item">
            <with-param name="key">journal</with-param>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <template match="issn">
        <call-template name="item">
            <with-param name="key">issn</with-param>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <!-- formatting markup -->
    <!-- see http://www.tei-c.org/release/doc/tei-xsl-common2/slides/teilatex-slides3.html -->

    <template match="*" mode="markup">
        <xsl:apply-templates mode="markup"/>
    </template>

    <template match="bold" mode="markup">
        <xsl:text>\textbf{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="italic" mode="markup">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="underline" mode="markup">
        <xsl:text>\uline{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="overline" mode="markup">
        <xsl:text>\textoverbar{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="sup" mode="markup">
        <xsl:text>\textsuperscript{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="sub" mode="markup">
        <xsl:text>\textsubscript{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="sc" mode="markup">
        <xsl:text>\textsc{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="monospace" mode="markup">
        <xsl:text>\texttt{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template name="string-replace-all">
        <param name="text"/>
        <param name="replace"/>
        <param name="by"/>
        <choose>
            <when test="contains($text, $replace)">
                <value-of select="substring-before($text, $replace)"/>
                <value-of select="$by"/>
                <call-template name="string-replace-all">
                    <with-param name="text" select="substring-after($text, $replace)"/>
                    <with-param name="replace" select="$replace"/>
                    <with-param name="by" select="$by"/>
                </call-template>
            </when>
            <otherwise>
                <value-of select="$text"/>
            </otherwise>
        </choose>
    </template>
</stylesheet>
