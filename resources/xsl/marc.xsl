<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" xpath-default-namespace="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="xs xd">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> May 12, 2016</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="record">
        <table class="table table-condensed">
            <tr>
                <td>leader</td>
                <td>
                    <xsl:apply-templates select="leader"/>
                </td>
            </tr>
            <tr>
                <td>control fields</td>
                <td>
                    <table class="table table-condensed">
                        <xsl:apply-templates select="controlfield"/>
                    </table>
                </td>
            </tr>
            <tr>
                <td>data fields</td>
                <td>
                    <table class="table table-condensed">
                        <xsl:apply-templates select="datafield"/>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="controlfield">
        <tr>
            <td>
                <xsl:value-of select="@tag"/>
            </td>
            <td>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="datafield">
        <tr>
            <td>
                <xsl:value-of select="@tag"/>
            </td>
            <td>
                <table class="table table-condensed">
                    <xsl:apply-templates select="subfield"/>
                </table>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="subfield">
        <tr>
            <td>
                <xsl:value-of select="@code"/>
            </td>
            <td>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>