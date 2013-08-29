xquery version "1.0-ml";

import module namespace sem   = "http://marklogic.com/semantics"             at "/MarkLogic/semantics.xqy";
import module namespace t-lib = "http://marklogic.com/semantics/triples-lib" at "/lib/triples-lib.xqy";

declare namespace house = "http://xml.house.gov/schemas/uslm/1.0";

for $law-doc in fn:collection("us-code")
let $title := $law-doc//house:title 
let $subject := 
  fn:concat(
    fn:namespace-uri($title),
    fn:string($title/@identifier)
  )
return 
( 
  sem:rdf-insert(t-lib:triple-from-element($subject, $title/house:heading)),
  if (fn:string($title/house:note) ne "") then
    sem:rdf-insert(t-lib:triple-from-element($subject, $title/house:note))
  else (),
  for $chapter in $title/house:chapter
  let $subj-chapter := 
    fn:concat(    
      fn:namespace-uri($chapter),
      fn:string($chapter/@identifier)
    )
  return
  (
    let $chap-predicate := fn:concat(fn:namespace-uri($chapter), "/chapter")
    return sem:rdf-insert(sem:triple(sem:iri($subject), sem:iri($chap-predicate), $subj-chapter)),
    sem:rdf-insert(t-lib:triple-from-element($subj-chapter, $chapter/house:heading))
  )
)


