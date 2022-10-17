xquery version "1.0-ml";

let $uris := cts:uris("", (), (cts:directory-query("/C:/chess/src/tournaments/")))

let $count := fn:count($uris)

return ($count, $uris) 