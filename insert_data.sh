#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# TRUNCATE Tables
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

    # TEAMS
    if [[ $WINNER != winner ]]
    then
      # Get team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

      # if not found
      if [[ -z $TEAM_ID ]]
      then
        # insert team
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

        if [[ INSERT_TEAM == 'INSERT 0 1' ]]
        then
          echo Inserted into teams $WINNER
        fi

        # get new game_id 
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

      fi

    fi

    if [[ $OPPONENT != opponent ]]
    then
      # Get team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      # if not found
      if [[ -z $TEAM_ID ]]
      then
        # insert team
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

        if [[ INSERT_TEAM == 'INSERT 0 1' ]]
        then
          echo Inserted into teams $OPPONENT
        fi

        # get new game_id 
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      fi
    fi

    if [[ $YEAR != year ]] || [[ $ROUND != round ]] || [[ $WINNER != winner ]] || [[ $OPPONENT != opponent ]] || [[ $WINNER_GOALS != winner_goals ]] || [[ $OPPONENT_GOALS != opponent_goals ]]
    then
        # Get game_id
        GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner='$WINNER_ID'")

        # Get winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")


        # Get opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

        # if not found
        if [[ -z $GAME_ID ]]
        then
            # insert year
            INSERT_YEAR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

            if [[ $INSERT_YEAR == 'INSERT 0 1' ]]
            then
                echo Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
            fi

            # get new game_id 
            GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner='$WINNER_ID'")
        fi
    fi

done