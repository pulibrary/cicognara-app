xquery version "3.0";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://library.princeton.edu/cicognara-app/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:media-type "text/xml";



declare variable $ciconum := request:get-parameter("ciconum", ());

let $item := collection($config:data-root)//tei:item[@n = $ciconum]
return $item
