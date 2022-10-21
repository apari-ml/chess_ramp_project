xquery version "1.0-ml";
declare namespace ch = "http://marklogic.com/mlu/chess-tournaments";

declare variable $URI as xs:string external;


let $source := fn:doc($URI)

let $tournamentname := $source/ch:tournament/ch:name/text()

let $tournamentid := $source/ch:tournament/ch:tournamentid/text()

let $playernames := for $player in $source/ch:tournament/ch:players/ch:player		
		    return <div>{fn:concat($player/ch:name/ch:firstname/string(), " ", 
			   $player/ch:name/ch:lastname/string())}</div>

let $doc :=
<envelope>
	<canonical>
		<tournamentname>{$tournamentname}</tournamentname>
		<tournamentid>{$tournamentid}</tournamentid>
		<playernames>{$playernames}</playernames>
	</canonical>
	<source>{$source}</source>
</envelope>

return xdmp:document-insert($URI, $doc, xdmp:permission("8010-chess-tournaments-reader", "read"), ("corb_transformed"))