xquery version "1.0-ml";

let $uris := ("/C:/chess/index.xqy", "/C:/chess/css/chess.css", "/C:/chess/images/banner.jpg")

let $count := fn:count($uris)

return ($count, $uris) 