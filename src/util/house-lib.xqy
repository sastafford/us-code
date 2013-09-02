xquery version "1.0-ml";

module namespace house-lib = "house.gov/lib";

import module namespace sem = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";

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

declare function house-lib:amendment(
  $note as element(house:note)
) as sem:triple* {
  if (fn:exists($note[@topic = "amendments"])) then
    for $ref in $note//house:ref
    let $subject := 
      sem:iri(
        fn:concat(
          fn:namespace-uri($note),
          "/amendment_", 
          house-lib:identifier($ref/@href)
        )
      )
    return
    (
      sem:triple($subject, sem:iri("rdf:type"), "house:amendment"),
      sem:triple($subject, sem:iri("dc:source"), xs:string($ref/text())) 
    )
  else 
    fn:error("HOUSELIB:NOTAMENDMENT", "This note is not an amendment")

};
