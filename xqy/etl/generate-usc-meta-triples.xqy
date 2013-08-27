xquery version "1.0-ml";
declare namespace house   = "http://xml.house.gov/schemas/uslm/1.0";
declare namespace dc      = "http://purl.org/dc/elements/1.1/"; 
declare namespace dcterms = "http://purl.org/dc/terms/";

let $doc := fn:collection("us-code")[1]
let $subject := fn:concat("http://xml.house.gov/schemas/uslm/1.0", $doc//house:title/@identifier)
for $meta in $doc//house:meta/element()
let $ns := 
  let $ns := fn:string(fn:namespace-uri-from-QName(fn:node-name($meta)))
  return if (fn:ends-with($ns, "/")) then $ns else fn:concat($ns, "/")
let $predicate := fn:concat($ns, fn:local-name($meta))
let $object := $meta/text()
return fn:concat($subject, " ", $predicate, " '", $object, "' .")
