xquery version "1.0-ml";

import module namespace h-lib = "house.gov/lib" at "/util/house-lib.xqy";
import module namespace sem   = "http://marklogic.com/semantics"             at "/MarkLogic/semantics.xqy";
import module namespace t-lib = "http://marklogic.com/semantics/triples-lib" at "/lib/triples-lib.xqy";

declare namespace house = "http://xml.house.gov/schemas/uslm/1.0";

for $law-doc in fn:collection("us-code")[2]/element()
let $title := $law-doc//house:title 
let $subject := 
  fn:concat(
    fn:namespace-uri($title), "/",
    h-lib:identifier($title/@identifier)
  )
return 
( 
  for $meta in $law-doc//house:meta/element()
  return t-lib:triple-from-element($subject, $meta),
  t-lib:triple-from-element($subject, $title/house:heading),
  if (fn:string($title/house:note) ne "") then
    sem:triple(sem:iri($subject), sem:iri("house:enactedBy"), xs:string($title/house:note[@topic = "enacting"]))
  else (),
  for $section in $title//house:section
  return h-lib:section-triples($section)
)


