xquery version "1.0-ml";

declare namespace house = "http://xml.house.gov/schemas/uslm/1.0";

for $section in fn:doc("/us/usc/t13")//house:section
let $subject := 
  fn:concat(
    fn:namespace-uri($section),
    fn:string($section/@identifier)
  )
let $heading := $section/house:heading
let $predicate := 
  fn:concat(
    fn:namespace-uri($section), "/",
    fn:name($section)
  )
return 
  sem:triple(
    sem:iri($subject), 
    sem:iri($predicate), 
    fn:normalize-space(fn:string($heading))
  )
