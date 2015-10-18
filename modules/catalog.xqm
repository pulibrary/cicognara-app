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
	return <li>{ $section/tei:head[1]/text() }</li>
};