xquery version "3.0";

module namespace app="http://library.princeton.edu/cicognara-app/templates";

import module namespace rest = "http://exquery.org/ns/restxq";
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://library.princeton.edu/cicognara-app/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute data-template="app:test" 
 : or class="app:test" (deprecated). The function has to take at least 2 default
 : parameters. Additional parameters will be mapped to matching request or session parameters.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
};



declare
    %rest:GET
    %rest:path("catalog/{$ciconum}")
function app:ciconum($ciconum as xs:string)
{


let $cr-item := collection($config:data-root)//tei:item [@n = $ciconum]
let $marc    := collection($config:data-root)//marc:record[ft:query(./marc:datafield[@tag="533"]/marc:subfield[@code="f"], concat($ciconum, "*"))]
let $rows    := collection($config:data-root)//row[ft:query(./Cico-Nr.___Original, concat($ciconum, "*"))]

return 
<result>
    <cr-item>{ $cr-item }</cr-item>
    <marc>{
        for $rec in $marc return 
        <rec>
            <title>{ $rec/marc:datafield[@tag="245"] }</title>
            <key>  { $rec/marc:datafield[@tag="533"]/marc:subfield[@code="f"] }</key>
        </rec>
    }</marc>
    <master>{ for $row in $rows return $row }</master>
</result>
};

declare
    %rest:GET
    %rest:path("master/{$ciconum}")
function app:cicomaster($ciconum as xs:string)
{
let $row := collection($config:data-root)//row[./Cico-Nr. = $ciconum]
return $row
};

declare
    %rest:GET
    %rest:path("marc/{$ciconum}")
function app:cicomarc($ciconum as xs:string)
{
let $marc    := collection($config:data-root)//marc:record[ft:query(.//marc:subfield[@code="f"], concat($ciconum, "*"))]
return $marc
};

declare
    %templates:wrap
function app:select($node as node(), $model as map(*), $keywords as xs:string?) 
{
    let $hits :=
        if ($keywords) then
            collection($config:data-root)//tei:item[ft:query(., $keywords)]
        else 
            ()
    return map {
    "keywords" : $keywords,    
    "selected-items" : $hits
    }
};

declare
function app:hitcount($node as node(), $model as map(*))
{
    count($model("selected-items"))
};

declare
function app:keywords($node as node(), $model as map(*))
{
    $model("keywords")
};


declare
function app:list-selections($node as node(), $model as map(*))
{
    let $selected-items := $model("selected-items")
    let $xsl := doc($config:app-root || "/resources/xsl/section.xsl")
    return
    <ol> {
    for $item in $selected-items
    return transform:transform($item, $xsl,())
    } </ol>
    
};

declare
function app:masterfile-display($node as node(), $model as map(*), $rownum as xs:string?)
{
    let $result :=
    if ($rownum) then
    let $row := doc($config:master-file)//row[./Cico-Nr. = $rownum]
    return
    <table class="table">
    {
        for $col in $row/*
        return 
        <tr>
            <td>{ local-name($col) }</td>
            <td>{ $col/text() }</td>
        </tr>
    }
    </table>
    else 
    <table class="table">
        <tr>
            <th>Heidelberg Number</th>
            <th>Microfilm Number</th>
            <th>Title</th>
        </tr>
    {
        let $rows := collection($config:data-root)//row
        for $row at $count in 
        subsequence($rows, 1, count($rows))
        let $hnum := $row/Cico-Nr./text()
        let $fnum := $row/Cico-Nr.___Original/text()
        let $title := $row/Title/text()
        return
        <tr>
            <td><a href="masterfile.html?rownum={$hnum}">{ $hnum }</a></td>
            <td>{ $fnum }</td>            
            <td>{ $title }</td>
        </tr>
    } </table>
    
    return $result
};

declare
function app:heidelberg-marcfile-display($node as node(), $model as map(*), $rownum as xs:string?)
{
    let $marcfile := doc($config:heidelberg-marc-file)
    let $marcrecs := $marcfile/marc:collection/marc:record
    return
        <table class="table">
        <tr>
            <th>ciconum</th>
            <th>title</th>
        </tr>
        {
            for $rec in $marcrecs
            let $title     := $rec/marc:datafield[@tag='245']
            let $cicofield := $rec/marc:datafield[@tag='776']/marc:subfield[@code='a']
            let $ciconum   :=
                if ($cicofield) then
                    for $field in $cicofield return
                    substring-after($field, 'The Cicognara Library ; ')
                else ()
            return
                <tr>
                    <td>{ $ciconum }</td>
                    <td>{  $title  }</td>
                </tr>
        }
        </table>
};

declare
function app:princeton-marcfile-display($node as node(), $model as map(*), $rownum as xs:string?)
{
    let $marcfile := doc($config:princeton-marc-file)
    let $marcrecs := $marcfile/marc:collection/marc:record
    return
        <table class="table">
        <tr>
            <th>099$a</th>
            <th>510$c</th>
            <th>title</th>
        </tr>
        {
            for $rec in $marcrecs
            let $title     := $rec/marc:datafield[@tag='245']
            let $cico1 := $rec/marc:datafield[@tag='099']/marc:subfield[@code='a']
            let $ciconum-099   :=
                if ($cico1) then
                    for $field in $cico1 return
                    substring-after($field, "49 no. ")
                else ()
                
            let $ciconum-510 := $rec/marc:datafield[@tag='510' and marc:subfield[@code='a'] = 'Cicognara,']/marc:subfield[@code='c']
            return
                <tr>
                    <td>{ $ciconum-099 }</td>
                    <td>{ $ciconum-510 }</td>
                    <td>{  $title  }</td>
                </tr>
        }
        </table>
};