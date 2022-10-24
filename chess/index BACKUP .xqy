xquery version "1.0-ml";
declare namespace ch = "http://marklogic.com/mlu/chess-tournaments";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare variable $options :=
  <options xmlns="http://marklogic.com/appservices/search">
  <constraint name="firstname">
	<range type="xs:string"
		collation="http://marklogic.com/collation/en/S1/AS/T00BB">
		<element ns="http://marklogic.com/mlu/chess-tournaments" name="firstname"/>
		<facet-option>limit=30</facet-option>
		<facet-option>frequency-order</facet-option>
		<facet-option>descending</facet-option>
	</range>
  </constraint>
  
	<constraint name="tournamentid">
		<word>
			<field name="tournamentid"/>
		</word>
	</constraint>
  
        <transform-results apply="snippet">
		<preferred-elements>
			<element ns="http://marklogic.com/mlu/chess-tournaments" name="description"/>
		</preferred-elements>
	</transform-results>
	
	<search:operator name="sort">
	
		<search:state name="name">
			<search:sort-order direction="ascending" type="xs:string">
				<search:element ns="http://marklogic.com/mlu/chess-tournaments" name="name"/>
			</search:sort-order>
			<search:sort-order>
				<search:score/>
			</search:sort-order>
		</search:state>
		
		<search:state name="newest">
		    <search:sort-order direction="ascending" type="xs:date">
		        <search:element ns="http://marklogic.com/mlu/chess-tournaments" name="startdate"/>
		    </search:sort-order>
		    <search:sort-order>
		        <search:score/>
		    </search:sort-order>
		</search:state>  
		
		<search:state name="firstname">
		    <search:sort-order direction="ascending" type="xs:string">
		        <search:element ns="http://marklogic.com/mlu/chess-tournaments" name="firstname"/>
		    </search:sort-order>
		    <search:sort-order>
		        <search:score/>
		    </search:sort-order>
		</search:state> 
		
		<search:state name="tournamentid">
		    <search:sort-order direction="ascending" type="xs:integer">
		        <search:element ns ="" name="tournamentid"/>
		    </search:sort-order>
		    <search:sort-order>
		        <search:score/>
		    </search:sort-order>
		</search:state>
		
	 </search:operator>
  </options>;

declare variable $results :=
	let $q := xdmp:get-request-field("q", "sort:newest")
	let $q := local:add-sort($q)
	return
		search:search($q, $options, xs:unsignedLong(xdmp:get-request-field("start","1")));

declare function local:result-controller()
{
	if(xdmp:get-request-field("date"))
	then local:date-check()
	else if(xdmp:get-request-field("q"))
		then local:search-results()
		else if(xdmp:get-request-field("uri"))
			then local:tournament-detail()  
			else local:default-results()
};



(: gets the current sort argument from the query string :)
declare function local:get-sort($q){
    fn:replace(fn:tokenize($q," ")[fn:contains(.,"sort")],"[()]","")
};

(: adds sort to the search query string :)
declare function local:add-sort($q){
    let $sortby := local:sort-controller()
    return
        if($sortby)
        then
            let $old-sort := local:get-sort($q)
            let $q :=
                if($old-sort)
                then search:remove-constraint($q,$old-sort,$options)
                else $q
            return fn:concat($q," sort:",$sortby)
        else $q
};

(: determines if the end-user set the sort through the drop-down or through editing the search text field or came from the advanced search form :)
declare function local:sort-controller(){
    if(xdmp:get-request-field("advanced")) 
    then 
        let $order := fn:replace(fn:substring-after(fn:tokenize(xdmp:get-request-field("q","sort:relevance")," ")[fn:contains(.,"sort")],"sort:"),"[()]","")
        return 
            if(fn:string-length($order) lt 1)
            then "relevance"
            else $order
    else if(xdmp:get-request-field("submitbtn") or not(xdmp:get-request-field("sortby")))
    then 
        let $order := fn:replace(fn:substring-after(fn:tokenize(xdmp:get-request-field("q","sort:newest")," ")[fn:contains(.,"sort")],"sort:"),"[()]","")
        return 
            if(fn:string-length($order) lt 1)
            then "relevance"
            else $order
    else xdmp:get-request-field("sortby")
};

(: builds the sort drop-down with appropriate option selected :)
declare function local:sort-options(){
    let $sortby := local:sort-controller()
    let $sort-options := 
            <options>
                <option value="relevance">relevance</option>
                <option value="name">name</option>
                <option value="startdate">startdate</option>
            </options>
    let $newsortoptions := 
        for $option in $sort-options/*
        return 
            element {fn:node-name($option)}
            {
                $option/@*,
                if($sortby eq $option/@value)
                then attribute selected {"true"}
                else (),
                $option/node()
            }
    return 
        <div id="sortbydiv">
             sort by: 
                <select name="sortby" id="sortby" onchange='this.form.submit()'>
                     {$newsortoptions}
                </select>
        </div>
};


declare function local:search-results()
{
   let $q := local:add-sort(xdmp:get-request-field("q"))
	
   let $results :=
	for $tournament in search:search($q, $options)/search:result
	let $uri := fn:data($tournament/@uri)
	let $chess-doc := fn:doc($uri)
	return 
	    <div>
		{if($chess-doc//ch:name) then <div class="tournamentname">{$chess-doc//ch:name/text()}</div> else()}
		{if($chess-doc//ch:tournamentid) then <div>TournamentID: {$chess-doc//tournamentid/text()}</div> else()}
		{if($chess-doc//ch:prize) then <div class="description">Prize: {$chess-doc//ch:prize/text()}</div> else()}
		{if($chess-doc//ch:description) then <div class="description">{local:description($tournament)}</div> else()}
		{if($chess-doc/game/players) then <div class="tournamentname">{$chess-doc/game/players/string()}</div> else()}
		{if($chess-doc/game/pgn) then <div>{$chess-doc/game/pgn/text()}</div> else()}
	    </div>
  return
    if($results)
    	then (local:sort-options(), $results)
    else <div>Sorry, no results for your search.<br/><br/><br/></div>
};

declare function local:description($tournament)
{
	for $text in $tournament/search:snippet/search:match/node()
	return
		if(fn:node-name($text) eq xs:QName("search:highlight"))
		then <span class="highlight">{$text/text()}</span>
		else $text
};

declare function local:default-results()
{
	(for $tournament in /ch:tournament 		 
		order by $tournament/ch:startdate
		return (<div>
			<div class="tournamentnamelarge">{$tournament/ch:name/text()}</div>
			<div class="description">{fn:tokenize($tournament//ch:description, " ") [1 to 10]} ...&#160;
			<a href="index.xqy?uri={xdmp:url-encode(fn:base-uri($tournament))}">[more]</a>
			</div>
			</div>) 	
	)[1 to 20]
};

declare function local:date-check()
{	(:shows all tournaments that are ongoing at specified date:)
	let $date := xdmp:get-request-field("date")
	return if($date castable as xs:date)
	
	then
	  let $date-docs := cts:search(fn:doc(),
					cts:and-query((
					  cts:element-range-query(xs:QName("ch:startdate"), "<=", xs:date($date)),
					  cts:element-range-query(xs:QName("ch:enddate"), ">=", xs:date($date)))
					))
					
	  for $date-doc in $date-docs
		return 
          <div>
			{if($date-doc//ch:name) then <div class="tournamentname">{$date-doc//ch:name/text()}</div> else()}
			{if($date-doc//ch:tournamentid) then <div>TournamentID: {$date-doc//tournamentid/text()}</div> else()}
			{if($date-doc//ch:prize) then <div class="description">Prize: {$date-doc//ch:prize/text()}</div> else()}
			{if($date-doc//ch:description) then <div class="description">{$date-doc//ch:description}</div> else()}
          </div>
		
	else <div>Invalid date entered.</div>
};

declare function local:tournament-detail()
{
	let $uri := xdmp:get-request-field("uri")
	let $tournament := fn:doc($uri) 
	return <div>
		<div class="tournamentnamelarge">{$tournament/ch:tournament/ch:name/text()}</div>
		{if ($tournament/ch:tournament/ch:location) then <div class="detailitem">location: {fn:concat($tournament/ch:tournament/ch:location/ch:city/string(), ", ", $tournament/ch:tournament/ch:location/ch:country/string())}</div> else ()}
		{if ($tournament/ch:tournament/ch:description) then <div class="detailitem">{$tournament/ch:tournament/ch:description}</div> else ()}
	</div>
};

declare function local:facets()
{
	for $facet in $results/search:facet
	let $facet-count := fn:count($facet/search:facet-value)
	let $facet-name := fn:data($facet/@name)
	return
		if($facet-count > 0)
		then <div class="facet">
			<div class="purplesubheading">
			<img src="images/checkblank.gif"/>{$facet-name}</div>
			{
				for $val in $facet/search:facet-value
				let $print := if($val/text()) then $val/text() else "Unknown"
				let $qtext := ($results/search:qtext)
				let $sort := local:get-sort($qtext)
				let $this :=
					if (fn:matches($val/@name/string(),"\W"))
					then fn:concat('"',$val/@name/string(),'"')
					else if ($val/@name eq "") then '""'
					else $val/@name/string()
				let $this := fn:concat($facet/@name,':',$this)
				let $selected := fn:matches($qtext,$this,"i")
				let $icon :=
					if($selected)
					then <img src="images/checkmark.gif"/>
					else <img src="images/checkblank.gif"/>
				let $link :=
					if($selected)
					then search:remove-constraint($qtext,$this,$options)
					else if(fn:string-length($qtext) gt 0)
					then fn:concat("(",$qtext,")"," AND ",$this)
					else $this
				let $link := if($sort and fn:not(local:get-sort($link))) then
				fn:concat($link," ",$sort) else $link
				let $link := fn:encode-for-uri($link)
				return
					<div class="facet-value">{$icon}<a
					href="index.xqy?q={$link}">
					{fn:lower-case($print)}</a> [{fn:data($val/@count)}]</div>
			}
			</div>
		else <div>&#160;</div>
};


xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>Chess Tournaments</title>
  <link href="css/chess.css" rel="stylesheet" type="text/css"/>
</head>


<body>
<div id="wrapper">
<div id="header"><a href="index.xqy"><img src="images/banner.jpg" width="918" height="153" border="0"/></a></div>
<div id="leftcol">
  <img src="images/checkblank.gif"/>{local:facets()}<br />
  <br />
  <div class="purplesubheading"><img src="images/checkblank.gif"/>check a date!</div>
  <form name="formdate" method="get" action="index.xqy" id="formdate">
    <img src="images/checkblank.gif" width="7"/>
    <input type="text" name="date" id="date" size="15"/> 
    <input type="submit" id="btndate" value="go"/>
  </form>
  <div class="tinynoitalics"><img src="images/checkblank.gif"/>(e.g. 2000-01-01)</div>
</div>
<div id="rightcol">
  <form name="form1" method="get" action="index.xqy" id="form1">
  <div id="searchdiv">
    <input type="text" name="q" id="q" size="50" value="{local:add-sort(xdmp:get-request-field("q"))}"/><button type="button" id="reset_button" onclick="document.getElementById('date').value = ''; document.getElementById('q').value = ''; document.location.href='index.xqy'">x</button>&#160;
    <input style="border:0; width:0; height:0; background-color: #A7C030" type="text" size="0" maxlength="0"/><input type="submit" id="submitbtn" name="submitbtn" value="search"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
  </div>
  <div id="detaildiv">
  {  local:result-controller()  }  	
  </div>
  </form>
</div>
<div id="footer"></div>
</div>
</body>
</html>