xquery version "1.0-ml";

import module namespace sem   = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";
import module namespace t-lib = "http://marklogic.com/semantics/triples-lib" at "/lib/triples-lib.xqy";
import module namespace house-lib = "house.gov/lib" at "/util/house-lib.xqy"; 

declare namespace house = "http://xml.house.gov/schemas/uslm/1.0";

for $section in fn:doc("/us/usc/t13")//house:section
let $subject := 
  fn:concat(
    fn:namespace-uri($section),
    house-lib:identifier($section/@identifier)
  )
return 
(
  t-lib:triple-from-element($subject, $section/house:heading),
  for $amendment in $section/house:notes/house:note[@topic eq "amendments"]
  return house-lib:amendment($amendment)
)  
