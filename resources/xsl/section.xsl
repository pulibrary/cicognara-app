<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="3.0" exclude-result-prefixes="xs math xd tei">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Oct 18, 2015</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:div[@type='section']">
        <article>
            <xsl:apply-templates/>
        </article>
    </xsl:template>
    <xsl:template match="tei:pb"/>
    <xsl:template match="tei:head">
        <head>
            <h2>
                <xsl:apply-templates/>
            </h2>
        </head>
    </xsl:template>
    <xsl:template match="tei:list[@type='catalog']">
        <ol class="catalog">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:label">
        <head>
            <span class="ciconum">
                <xsl:apply-templates/>
            </span>
        </head>
    </xsl:template>
    <xsl:template match="tei:bibl">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:note">
        <p class="note">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:title">
        <span class="title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>