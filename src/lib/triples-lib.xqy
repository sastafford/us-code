xquery version "1.0-ml";

module namespace t-lib = "http://marklogic.com/semantics/triples-lib";

declare function t-lib:triple-from-element(
  $subject as xs:string,
  $el as element()
) as sem:triple {
  sem:triple(
    sem:iri($subject),
    sem:iri(fn:concat(fn:namespace-uri($el), "/", fn:name($el))),
    fn:normalize-space(fn:string($el))
  )
};
