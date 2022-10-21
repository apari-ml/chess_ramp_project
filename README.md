#readme for solo ramp chess project
=========
**admin user:pass === apari:admin**

----------
**Order of commands in terminal from C:/chess**

Deploy & load everything into the database
>gradle mlDeploy
>
>gradle loadTournaments
>
>gradle loadGames
>
>gradle loadCSS
>
>gradle loadImages
>
>gradle loadRestFile
>
>gradle loadIndex


#Transform tournament and game files with corb
=========
>cd corb *(to to C:/chess/corb)*
>
>----------
>*envelopes tournament files*
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_tournaments.properties com.marklogic.developer.corb.Manager
>
>
>----------
>*splits games into seperate docs & inserts them*
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_games.properties com.marklogic.developer.corb.Manager
>
>
>----------
>*gives non-admin users permissions*
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_permissions.properties com.marklogic.developer.corb.Manager
>
>
>----------
>*adds protected paths for sensitive info*
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_paths.properties com.marklogic.developer.corb.Manager

#Install custom rest file for custom GET function
=========
>cd ../ *(back to C:/chess)*
>
>curl --anyauth --user apari:admin -X PUT -H "Content-type: application/xquery" -d@"./chess.xqy" "http://localhost:8010/LATEST/config/resources/chess"



#To use custom rest endpoint
=========
>curl --anyauth --user apari:admin -X GET -H "Accept: application/xml" "http://localhost:8010/LATEST/resources/chess?rs:arg1=SEARCHTERMHERE"

##example where you search for spain
=========
>curl --anyauth --user apari:admin -X GET -H "Accept: application/xml" "http://localhost:8010/LATEST/resources/chess?rs:arg1=spain"
