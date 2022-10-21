xquery version "1.0-ml";

xdmp:document-add-permissions("/C:/chess/index.xqy", (xdmp:permission("8010-chess-tournaments-reader", "execute")));
xdmp:document-add-permissions("/C:/chess/css/chess.css", (xdmp:permission("8010-chess-tournaments-reader", "execute")));
xdmp:document-add-permissions("/C:/chess/images/banner.jpg", (xdmp:permission("8010-chess-tournaments-reader", "execute")));

xdmp:document-add-permissions("/C:/chess/index.xqy", (xdmp:permission("8010-chess-tournaments-reader", "read")));
xdmp:document-add-permissions("/C:/chess/css/chess.css", (xdmp:permission("8010-chess-tournaments-reader", "read")));
xdmp:document-add-permissions("/C:/chess/images/banner.jpg", (xdmp:permission("8010-chess-tournaments-reader", "read")));