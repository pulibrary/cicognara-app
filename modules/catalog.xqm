xquery version "3.0";

module namespace catalog="http://library.princeton.edu/cicognara-app/catalog";


import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://library.princeton.edu/cicognara-app/config" at "config.xqm";


declare namespace tei="http://www.tei-c.org/ns/1.0";

declare %templates:wrap function catalog:toc($node as node(), $model as map(*))
as element()*
{
	let $sections := collection($config:data-root)//tei:div[@type='section']
	for $section in $sections
	let $label := $section/tei:head[1]/text()
	let $num   := xs:string($section/@n)
	return <li><a href="catalog.html?n={$num}">{ $label }</a></li>
};

declare %templates:wrap function catalog:section($node as node(), $model as map(*), $n as xs:string?)
as map(*)?
{
	let $hit := if (not(empty($n))) then
		collection($config:data-root)//tei:div[@n = $n]
	else ()
	return map { "selected-section" : $hit }
};

declare %templates:wrap function catalog:section-display($node as node(), $model as map(*))
as element()?
{
	let $section := $model("selected-section")
	let $xsl := doc($config:app-root || "/resources/xsl/section.xsl")
	let $chunk := if ($section) then
		transform:transform($section, $xsl, ())
	else ()
	return $chunk
};