#!/bin/bash
# Script to return information for element inputted as an argument.

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [ -z "$1" ]
  then
    # If no input argument, break with exit text
    echo Please provide an element as an argument.
  else
    if [[ $1 =~ ^[0-9]+$ ]] # if input type is atomic number
    then
      # PSQL atomic number
      SELECT_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius\
       FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN\
        types USING(type_id) WHERE atomic_number = $1")
    else # if input type is symbol or name
      # PSQL atomic number
      SELECT_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius\
       FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN\
        types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
    fi

    if [[ -z $SELECT_ELEMENT ]]
      then
      echo I could not find that element in the database.
    else
      read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING <<< $SELECT_ELEMENT
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
fi