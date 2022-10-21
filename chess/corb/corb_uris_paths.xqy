xquery version "1.0-ml";

let $uris := ("/C:/chess/index.xqy")

let $count := fn:count($uris)

return ($count, $uris) 