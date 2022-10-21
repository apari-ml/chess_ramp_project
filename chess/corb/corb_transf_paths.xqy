xquery version "1.0-ml";

import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
sec:protect-path("//ch:bankinfo", (sec:security-path-namespace("ch", "http://marklogic.com/mlu/chess-tournaments")),  (xdmp:permission("8010-chess-tournaments-admin", "read")));

import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
sec:protect-path("//ch:address", (sec:security-path-namespace("ch", "http://marklogic.com/mlu/chess-tournaments")),  (xdmp:permission("8010-chess-tournaments-admin", "read")));

import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
sec:protect-path("//ch:phone", (sec:security-path-namespace("ch", "http://marklogic.com/mlu/chess-tournaments")),  (xdmp:permission("8010-chess-tournaments-admin", "read")));