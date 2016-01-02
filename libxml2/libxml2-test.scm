(load "libxml2")


(defn test-xpath1 ()
  (letc
   [doc    (xmlParseFile "cars.xml")
   out    (xpath-eval doc "//car/name/text()")
   ]

   (xmlFreeDoc doc)
   (println (str out))
   ))


(defn test-xpath2 ()
  (letc
   [doc    (xmlParseFile "cars.xml")
   out    (xpath-eval doc "//car/@country/text()")
   ]

   (xmlFreeDoc doc)
   (println out)
   ))


(defn test-xpath3 ()
  (letc
   [doc    (xmlParseFile "cars.xml")
    out    (xpath-eval doc "//carsdad/nsadame/text()")
   ]

   (xmlFreeDoc doc)
   (println (str  out))
   ))


(defn test-xpath4 ()
  (letc
   [doc    (xmlParseFile "not-exists-cars.xml")
    out    (xpath-eval doc "//carsdad/nsadame/text()")
   ]

   (xmlFreeDoc doc)
   (println (str  out))
   ))

(do
  (test-xpath1)

  (test-xpath2)

  (test-xpath3)

  (test-xpath4)
 )

(comment
 (begin

   (load "libxml2")

   (def doc (xmlParseFile "cars.xml"))

   (def context (xmlXPathNewContext doc))

   (def result  (xmlXPathEvalExpression "//carsdas/name/text()" context))

   (def nodeset (xmlXPathObject->nodesetval result))

   (bind-nil xmlNodeSet->nodeNr nodeset 0))


 (bind-nil inc 2 0))
