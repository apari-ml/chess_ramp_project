xquery version "1.0-ml";

let $list_of_players := ("Magnus Carlsen", "Hikaru Nakamura", "Alireza Firouzja", "David Navara", "Fabiano Caruana", "Maxime Vachier-Lagrave", "Wesley So")
let $num_players := fn:count($list_of_players)

(:  starting at the 10th ] right bracket, copy all info until you get to a [ left bracket  :)

(:gets the entire file stored as a string for regex tokenization fun shenanigans:)
let $text := fn:unparsed-text("/C:/chess/src/games/Morphy.pgn", "UTF-8")
let $num_games := (fn:floor((xs:int(fn:count(fn:tokenize($text, "\]")))) div 10))

for $i in (1 to $num_games) (: returns the number of games in the file :)
  let $doc := fn:tokenize(fn:tokenize($text, "\]")[$i*10+1], "\[")[1] (: returns Xth game ::: 1=11, 2=21, etc :)

  let $nums := (for $i in (1 to $num_players)
  order by xdmp:random()
  return $i)[1 to 2]
  
  let $doc_node := 
  <game>
    <tournamentid>{($i mod 7) + 1}</tournamentid> 
    <players>
      <div>White: {$list_of_players[$nums][1]}</div>
      <div>Black: {$list_of_players[$nums][2]}</div>
    </players>
    <pgn>{$doc}</pgn>
  </game> 

  (:turns string of game notation into type node for insertion - still inside for loop:)
  (:inserts & creates URI based on game number:)
  (:adds a collection tag to each file on insertion:)
  return xdmp:document-insert(fn:concat("Game ", $i, ".xml"), $doc_node, 
                              map:map() => map:with("collections", ("Game"))
										=> map:with("permissions", 
											(xdmp:default-permissions("object"),
											xdmp:permission("8010-chess-tournaments-reader", "read", "object"))))