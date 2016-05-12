xquery version "3.0";

module namespace catalog="http://library.princeton.edu/cicognara-app/catalog";
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://library.princeton.edu/cicognara-app/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace marc="http://www.loc.gov/MARC21/slim";

declare function catalog:_item-by-ciconum($ciconum as xs:string)
as element()
{
    doc($config:catalogo)//tei:list[@type='catalog']/tei:item[@n=$ciconum]
};

declare function catalog:_items-by-dclnum($dclnum as xs:string)
as element()+
{
    doc($config:catalogo)//tei:list[@type='catalog']/tei:item[contains(@corresp, $dclnum)]
};

declare function catalog:_marc-by-ciconum($ciconum as xs:string)
as element()*
{
    doc($config:princeton-marc-file)//marc:datafield[@tag='024'][marc:subfield[@code='2'] = 'cico'][marc:subfield[@code='a'] = $ciconum]/ancestor::marc:record
};


declare %templates:wrap function catalog:item-by-ciconum($node as node(), $model as map(*), $ciconum as xs:string?)
as map(*)
{
    let $hit :=
        if ($ciconum) then 
           catalog:_item-by-ciconum($ciconum)
        else ()
    return map { "query" : $ciconum, "selected-items" : $hit } 
};

declare function catalog:list-selections($node as node(), $model as map(*))
as element()*
{
    let $selections := $model("selected-items")
    let $xsl := doc($config:app-root || "/resources/xsl/section.xsl")
    for $entry in $selections
     let $chunk := transform:transform($entry, $xsl, ())
     let $marcrecs := catalog:_marc-by-ciconum($entry/@n)
	 return 
	   <table><tr>
           <td>{ $chunk }</td>
	       <td>{ $marcrecs }</td>
	   </tr></table>
};


declare %templates:wrap function catalog:toc($node as node(), $model as map(*))
as element()*
{
	let $sections := doc($config:catalogo)//tei:div[@type='section']
	for $section in $sections
	let $label := $section/tei:head[1]/text()
	let $num   := xs:string($section/@n)
	return <li><a href="catalogo.html?section={$num}">{ $label }</a></li>
};

declare %templates:wrap function catalog:section($node as node(), $model as map(*), $section as xs:string?)
as map(*)?
{
	let $hit := if (not(empty($section))) then
		collection($config:data-root)//tei:div[@n = $section]
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