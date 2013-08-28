xquery version "1.0-ml";

import module namespace t-lib = "http://marklogic.com/semantics/triples-lib" at "/lib/triples-lib.xqy";
declare namespace house = "http://xml.house.gov/schemas/uslm/1.0";

for $section in fn:doc("/us/usc/t13")//house:section
let $subject := 
  fn:concat(
    fn:namespace-uri($section),
    fn:string($section/@identifier)
  )
return t-lib:triple-from-element($subject, $section/house:heading)
