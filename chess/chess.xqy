xquery version "1.0-ml";

(: Namespace pattern must be:  
 : "http://marklogic.com/rest-api/resource/{$rname}" 
 : and prefix must match resource name :)
module namespace chess =
  "http://marklogic.com/rest-api/resource/chess";

declare default function namespace
  "http://www.w3.org/2005/xpath-functions";
declare option xdmp:mapping "false";

(: Conventions: 
 : Module prefix must match resource name, 
 : and function signatures must conform to examples below.
 : The $context map carries state between the extension
 : framework and the extension.
 : The $params map contains parameters set by the caller,
 : for access by the extension.
 :)




(: Function responding to GET method - must use local name 'get':)
declare function chess:get(
    $context as map:map,
    $params  as map:map
) as document-node()*
{
    (: set 'output-type', used to generate content-type header :)
    let $output-type := map:put($context,"output-type","application/xml") 
    let $arg1 := map:get($params,"arg1")
	
    let $content := cts:search(fn:collection(), cts:word-query($arg1))
		
    (: must return document node(s) :)		
    return document { $content } 
};
