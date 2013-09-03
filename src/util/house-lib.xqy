xquery version "1.0-ml";

module namespace house-lib = "house.gov/lib";

import module namespace sem = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";
import module namespace t-lib = "http://marklogic.com/semantics/triples-lib" at "/lib/triples-lib.xqy";

declare namespace house   = "http://xml.house.gov/schemas/uslm/1.0";
declare namespace dc = "http://purl.org/dc/elements/1.1/";

declare function house-lib:identifier(
  $id as attribute()
) as xs:string {
  fn:replace(
    fn:replace(fn:string($id), "^/us/[A-Za-z]*/", ""),
    "[/ ]",
    "_"
  )
};

declare function house-lib:section-triples(
  $section as element(house:section) 
) as sem:triple* {
  let $subject := 
    fn:concat(
      fn:namespace-uri($section), "/",
      house-lib:identifier($section/@identifier)
    )
  return 
  (
    sem:triple(sem:iri($subject), sem:iri("rdf:type"), sem:iri("house:section")),
    t-lib:triple-from-element($subject, $section/house:heading),
    for $amendment in $section/house:notes/house:note[@topic eq "amendments"]
    return house-lib:amendment($subject, $amendment)
  )  
};

declare function house-lib:amendment(
  $section-iri as xs:string,
  $note        as element(house:note)
) as sem:triple* {
  if (fn:exists($note[@topic = "amendments"])) then
    for $ref in $note//house:ref
    let $amendment-id := house-lib:identifier($ref/@href)
    let $subject := 
      sem:iri(
        fn:concat(
          fn:namespace-uri($note),
          "/amendment_", 
          $amendment-id
        )
      )
    return
    (
      sem:triple($subject, sem:iri("rdf:type"), sem:iri("house:amendment")),
      sem:triple($subject, sem:iri("house:amends"), sem:iri($section-iri)),
      sem:triple($subject, sem:iri("dc:source"), xs:string($ref/text())) 
    )
  else 
    fn:error("HOUSELIB:NOTAMENDMENT", "This note is not an amendment")

};
