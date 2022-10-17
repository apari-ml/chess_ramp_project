#readme for solo ramp chess project --- user:pass === apari:admin
=========

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


######Transform tournament and game files with corb
>cd corb
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_tournaments.properties com.marklogic.developer.corb.Manager
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_games.properties com.marklogic.developer.corb.Manager


######Install custom rest file for custom GET function
>cd ../ (back to C:/chess)
>
>curl --anyauth --user apari:admin -X PUT -H "Content-type: application/xquery" -d@"./chess.xqy" "http://localhost:8010/LATEST/config/resources/chess"



##To use custom rest endpoint
>curl --anyauth --user apari:admin -X GET -H "Accept: application/xml" "http://localhost:8010/LATEST/resources/chess?rs:arg1=SEARCHTERMHERE"

##example where you search for spain
>curl --anyauth --user apari:admin -X GET -H "Accept: application/xml" "http://localhost:8010/LATEST/resources/chess?rs:arg1=spain"
