#readme for solo ramp chess project
=========
**admin user:pass === apari:admin**

>can search for games in a certain tournament by searching tournamintid:#
>where # is an integer 1-7

----------
**Order of commands in terminal from C:/chess**

Deploy & load everything into the database
>gradle mlDeploy
>
>gradle loadTournaments
>
>gradle loadGames


#Transform tournament and game files with corb
=========
>cd corb *(to to C:/chess/corb)*
>
>----------
>*envelopes tournament files - replaces originals*
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_tournaments.properties com.marklogic.developer.corb.Manager
>
>
>----------
>*splits games into seperate docs & inserts them*
>
>java -server -cp marklogic-xcc-10.0.9.5.jar;marklogic-corb-2.5.4.jar -DOPTIONS-FILE=corb_games.properties com.marklogic.developer.corb.Manager
>

#Install custom rest file for custom GET function
=========
>cd ../ *(back to C:/chess)*
>
>curl --anyauth --user apari:admin -X PUT -H "Content-type: application/xquery" -d@"./chess.xqy" "http://localhost:8011/LATEST/config/resources/chess"



#To use custom rest endpoint
=========
>curl --anyauth --user apari:admin -X GET -H "Accept: application/xml" "http://localhost:8011/LATEST/resources/chess?rs:arg1=SEARCHTERMHERE"

##example where you search for spain
=========
>curl --anyauth --user apari:admin -X GET -H "Accept: application/xml" "http://localhost:8011/LATEST/resources/chess?rs:arg1=spain"
