The feet_helper tool is relatively simple and just over 200 lines (including comments).  Two of the functions are straight from the fleetctl tool, but the rest perform some sort of output manipulation or iteration over data to achieve the desired output.

## Requirements  

* fleetctl must be setup and authenticated (post fleetctl login)  
* sed, grep, tail, cut, echo commands  

## Help Menu  
Activate the help menu by providing no options, -h, or --help.  

    Usage:  ./fleet_helper.sh <function>  
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


## Listing Packs and Queries
The feet_helper can list packs and queries in simple text format using the following two functions:

* listpacks - Lists pack names only within the Kolide Fleet instance  
* listqueries - Lists query names only within the Kolide Fleet instance  

~~~~
./fleet_helper.sh listpacks
users pack                   
osquery_info pack            
process_open_sockets pack    
programs pack                
network_connection_listening
~~~~

## Exporting (All or select) Packs and Queries
The feet_helper can export all or select packs and queries using the following four functions:

* exportpacks - Exports all packs in yaml format
* exportqueries - Exports all queries in yaml format
* exportpack <pack_name> - Exports a specified pack in yaml format
* exportquery <query_name> - Exports a specified query in yaml format

~~~~
./fleet_helper.sh exportqueries
apiVersion: v1
kind: query
spec:
  description: Query all users
  name: users query
  query: SELECT * FROM users
---
apiVersion: v1
kind: query
spec:
  description: Query the version of osquery
  name: osquery_info query
  query: SELECT * FROM osquery_info
--SNIP--
~~~~

## Exporting a Specific Pack and All Associated Queries
This feature is critical to sharing queries within a pack.  The feet_helper can export a pack and all associated queries as well using the following function:

* exportpackquery <pack_name> - Exports a pack and all associated queries in yaml format

~~~~
./fleet_helper.sh exportpackquery "network_connection_listening"
apiVersion: v1
kind: pack
spec:
  id: 14
  name: network_connection_listening
  queries:
--SNIP--
---
Snaphost_Windows_Process_Listening_Port
apiVersion: v1
kind: query
spec:
  description: Returns the Listening port List - ATT&CK T1043,T1090,T1094,T1205,T1219,T1105,T1065,T1102
  name: Snaphost_Windows_Process_Listening_Port
  query: select p.name, p.path, lp.port, lp.address, lp.protocol  from listening_ports
    lp LEFT JOIN processes p ON lp.pid = p.pid WHERE lp.port != 0 AND p.name != '';
~~~~

## Exporting All Packs and Queries
This feature is useful for backing up packs and queries or sharing an entire environment with someone else.  The feet_helper can export all packs and queries to yaml using the following function:

* exportall - Warning!  This exports all packs and all queries in yaml format

~~~~
./fleet_helper.sh exportall > exportall.yaml
~~~~

We won't show the output on this function because the output is quite lengthy -- hence why we recommend redirecting the output to a file.
