#!/bin/bash
# Script:  fleet_helper.sh
# Description:  fleetctl helper script.  Designed to use fleetctl and prototype desired export features.
# Requirements:  fleetctl must be setup and authenticated (post fleetctl login)
# Requirements:  sed, grep, tail, cut, echo commands
# Author:  Tony Lee (ANLEE2 -at- VT.EDU)


#### FUNCTIONS ####

function usage {
    echo
    echo "Usage:  ./fleet_helper.sh <function>

Note: All functions output to stdout.  Redirect to .yaml files as needed.

Possible functions:
 listpacks - Lists pack names only within the Kolide Fleet instance
 listqueries - Lists query names only within the Kolide Fleet instance
 exportpacks - Exports all packs in yaml format
 exportqueries - Exports all queries in yaml format
 exportpack <pack_name> - Exports a specified pack in yaml format
 exportquery <query_name> - Exports a specified query in yaml format
 exportpackquery <pack_name> - Exports a pack and all associated queries in yaml format
 exportall - Warning!  This exports all packs and all queries in yaml format
"
}


function listpacks {
	echo -n "`fleetctl get p | grep -v '+' | tail -n +2 | cut -f 2 -d '|' | sed 's/^.//' | sed -r '/^\s*$/d'`"
	echo
}


function listqueries {
	echo -n "`fleetctl get q | grep -v '+' | tail -n +2 | cut -f 2 -d '|' | sed 's/^.//' | sed -r '/^\s*$/d'`"
	echo
}


function exportpacks {

        IFS=$'\r'
        packs=()
        while read -r line; do
                packs+=( "$line" )
        done < <( fleetctl get p | grep -v '+' | tail -n +2 | cut -f 2 -d '|' | sed 's/^.//' | sed -r '/^\s*$/d' )

        for i in "${packs[@]}"; do
                fleetctl get p ${i}
		echo "---"
        done

}


function exportqueries {

        IFS=$'\r'
        queries=()
        while read -r line; do
                queries+=( "$line" )
        done < <( fleetctl get q | grep -v '+' | tail -n +2 | cut -f 2 -d '|' | sed 's/^.//' | sed -r '/^\s*$/d' )

        for i in "${queries[@]}"; do
                fleetctl get q ${i}
                echo "---"
        done

}


function exportpack () {
	arg="$1"
        fleetctl get p "${arg}"
        echo
}


function exportquery () {
	arg="$1"
        fleetctl get q "${arg}"
        echo
}


function exportpackquery () {
	arg="$1"

	# Output the Pack Info
        fleetctl get p "${arg}"
        echo "---"

	# Output each query in the Pack
        IFS=$'\r'
        queries=()
        while read -r line; do
                queries+=( "$line" )
	done < <( fleetctl get p "${arg}" | grep name: | tail -n +2 | cut -f 2 -d ':' | sed 's/^.//' )


        for i in "${queries[@]}"; do
		echo ${i}
                fleetctl get q ${i}
                echo "---"
        done	
        echo
}


function exportall {

	IFS=$'\r'
	packs=()
	while read -r line; do
		packs+=( "$line" )
	done < <( fleetctl get p | grep -v '+' | tail -n +2 | cut -f 2 -d '|' | sed 's/^.//' | sed -r '/^\s*$/d' )

	for i in "${packs[@]}"; do
		echo -e "fleetctl get p \"${i}\""
	done

}


#### MAIN ####

# Usage Statement for no arguments provided # 

#echo $1
#echo $2
#echo $#

if [ $# -eq 0 ]; then usage; fi

# Get first argument
func="$1"

case "$func" in

'-h' | '--help' )  # provide usage help
       	usage
	;;

'listpacks' )  # list the packs from Kolide Fleet
       	listpacks
	;;

'listqueries' ) # list the queries from Kolide Fleet
       	listqueries
	;;

'exportpacks' ) # export packs in yaml from Kolide Fleet
       	exportpacks
	;;

'exportqueries' ) # export queries in yaml from Kolide Fleet
       	exportqueries
	;;

'exportpack' ) # export a specific pack in yaml from Kolide Fleet
	if [ $# -eq 2 ]; then
		argument=$2
		exportpack "$argument"
	else	
		echo
		echo "Error:  Argument required."
		usage
		exit 1
	fi
	;;

'exportquery' ) # export a specific query in yaml from Kolide Fleet
	if [ $# -eq 2 ]; then
		argument=$2
		exportquery "$argument"
	else	
		echo
		echo "Error:  Argument required."
		usage
		exit 1
	fi
	;;


'exportpackquery' ) # export a specific pack and all of the associated queries in yaml from Kolide Fleet
	if [ $# -eq 2 ]; then
		argument=$2
		exportpackquery "$argument"
	else	
		echo
		echo "Error:  Argument required."
		usage
		exit 1
	fi
	;;

'exportall' ) # export all packs and then all queries
       	exportpacks
       	exportqueries
	;;

'*' ) # Did not match anything above
       	echo "Invalid syntax"
	usage
	;;

esac
