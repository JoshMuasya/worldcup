#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# TEAMS

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do 

  # Remove Header 
  if [[ $YEAR != year ]]
  then

    # Get two team ids
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $WINNER_ID ]]
    then

      # Insert winner
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER == 'INSERT 0 1' ]]
      then

        echo Inserted winner: $WINNER

      fi

    fi

    # If not found
    if [[ -z $OPPONENT_ID ]]
    then

      # Insert Opponent
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
      then

        echo Inserted opponent: $OPPONENT

      fi

    fi

  fi

done

# GAMES
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  # Remove Header
  if [[ $YEAR != year ]]
  then

    # Get winner and opponent id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE teams.name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE teams.name='$OPPONENT'")

    # Insert data into Games
    INSERT_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

    if [[ $INSERT_DATA == 'INSERT 0 1' ]]
    then

      echo Inserted data: $YEAR, $ROUND, $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS

    fi

  fi

done