;;
;; File:         libxml2.ss
;; Description:  Wrapper to libxml2 library
;; Author:       Caio Rodrigues <caiorss.rodrigues@gmail.com>
;;
;;
;; Compilation:
;;        (compile-file "libxml2.ss"
;;        ld-options:
;;        (read-process "xml2-config" "--cflags" "--libs"))
;;
;;
;; Libxml2 Documentation:
;;  - http://xmlsoft.org/html/libxml-tree.html
;;  - http://xmlsoft.org/html/libxml-xpath.html
;;  - http://xmlsoft.org/APIconstructors.html

(include "ffi-tools.scm")

(c-include "<string.h>")
(c-include "<libxml/tree.h>")

(c-include "<libxml/parser.h>")
(c-include "<libxml/xpath.h>")
(c-include "<libxml/xmlmemory.h>")

(c-declare
#<<end-c-code

struct xmlAttr;
struct xmlNode;



end-c-code
)

(c-define-type xmlAttr (struct "xmlAttr"))
(c-define-type xmlAttrPtr (pointer xmlAttr #f))
(c-define-type xmlAttribute (struct "xmlAttribute"))

(c-define-type xmlNode (struct "xmlNode"))
(c-define-type xmlNodePtr (pointer xmlNode #f))

(c-define-type xmlNodeSet (struct "xmlNodeSet"))
(c-define-type xmlNodeSetPtr (pointer xmlNodeSet #f))

(c-define-type xmlDoc (struct "xmlDoc"))
(c-define-type xmlDocPtr (pointer  xmlDoc #f))

(c-define-type xmlXPathObject (struct "xmlXPathObject"))
(c-define-type xmlXPathObjectPtr (pointer xmlXPathObject #f))

(c-define-type xmlXPathContext (struct "xmlXPathContext"))
(c-define-type xmlXPathContextPtr (pointer xmlXPathContext))

;;(c-define-type xmlChar  "char")
;;(c-define-type xmlChar* (pointer xmlChar #f))
(c-define-type xmlChar* char-string)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;  DATA TYPES                  ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;; C- Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; Parse a file to Xml
(defc-f xmlParseFile (char-string) xmlDocPtr )

;;; Save a parsed xml Document to a file
(defc-f xmlSaveFormatFile (char-string xmlDocPtr int) void)

;;; Get the Top Node of a XML document
(defc-f xmlDocGetRootElement (xmlDocPtr) xmlNodePtr)

(defc-f xmlXPathNewContext (xmlDocPtr) xmlXPathContextPtr)


;;;;; Clean functions to free the memory
;;;
(defc-f xmlCleanupParser () void)

(defc-f xmlFree (xmlChar*) void)
(defc-f xmlFreeDoc (xmlDocPtr) void)
(defc-f xmlXPathFreeContext (xmlXPathContextPtr) void)
(defc-f xmlXPathFreeObject  (xmlXPathObjectPtr) void)


;; Get a XML property of a node between the tags.
;;
(defc-f xmlGetProp (xmlNodePtr xmlChar*) xmlChar*)


;; xmlChar *	xmlGetNsProp		(const xmlNode * node,
;; 					 const xmlChar * name,
;; 					 const xmlChar * nameSpace)
(defc-f xmlGetNsProp (xmlNodePtr xmlChar* xmlChar*) xmlChar*)


;; xmlChar *	xmlNodeListGetString	(xmlDocPtr doc,
;; 					 const xmlNode * list,
;; 					 int inLine)
(defc-f xmlNodeListGetString
  (xmlDocPtr xmlNodePtr int)
   xmlChar*
  )

;;; xmlChar *	xmlNodeGetContent	(const xmlNode * cur)
(defc-f xmlNodeGetContent (xmlNodePtr) xmlChar*)

;;; int	xmlNodeIsText	(const xmlNode * node)
(defc-f xmlNodeIsText (xmlNodePtr) int)



;; xmlNodePtr xmlNextElementSibling	(xmlNodePtr node)
;;
(defc-f xmlNextElementSibling (xmlNodePtr) xmlNodePtr)




(defc-f  xmlXPathEvalExpression
  (xmlChar* xmlXPathContextPtr)
  xmlXPathObjectPtr
  )


(def xmlXPathObject->nodesetval
     (c-lambda
      (xmlXPathObjectPtr)
      xmlNodeSetPtr
      "
      xmlXPathObjectPtr ptr ;
      ptr = ___arg1 ;
      ___result_voidstar =  ptr->nodesetval ;
      "
))


(def xmlNodeSet->nodeNr
     (c-lambda
      (xmlNodeSetPtr)
      int
      "
      xmlNodeSetPtr ptr ;
      ptr = ___arg1 ;
      ___result = ptr->nodeNr ;
       "
      ))

(def xmlNodeSet->nodeTab
     (c-lambda
      (xmlNodeSetPtr)
      (pointer xmlNodePtr)
      "
      xmlNodeSetPtr ptr ;
      ptr = ___arg1 ;
      ___result_voidstar = ptr->nodeTab ;
       "
      ))

(def nodeTab->get
     (c-lambda
      ((pointer  xmlNodePtr) int)
      xmlNodePtr

      "
      ___result_voidstar = ___arg1 [___arg2] ;

      "
      ))



(def xmlNode->name
          (c-lambda
           (xmlNodePtr)
           char-string

"xmlNodePtr ptr;
ptr = ___arg1;
___result = ptr->name ;
"
   ))




(def xmlNode->content
          (c-lambda
           (xmlNodePtr)
           char-string

"xmlNodePtr ptr;
ptr = ___arg1;
___result = ptr->content ;
"
   ))

(def xmlNode->next
          (c-lambda   (xmlNodePtr) xmlNodePtr

          "
          xmlNodePtr ptr;
          ptr = ___arg1 ;
          ___result_voidstar = ptr->next ;
         "
          ))


(def xmlNode->type
     (c-lambda
      (xmlNodePtr)
      int
      "
      xmlNodePtr ptr;
      ptr = ___arg1 ;
      ___result = ptr->type ;"
      ))


(def xmlNode->children
          (c-lambda   (xmlNodePtr) xmlNodePtr

          "
          xmlNodePtr ptr;
          ptr = ___arg1 ;
          ___result_voidstar = ptr->children ;
         "
          ))

(def xmlNode->properties
  (c-lambda (xmlNodePtr) xmlAttrPtr
            "
            xmlNodePtr ptr ;
            ptr = ___arg1 ;
            ___result_voidstar = ptr->properties ;
            "
            ))



(def xmlAttr->next
  (c-lambda (xmlAttrPtr) xmlAttrPtr
            "
            xmlAttrPtr ptr ;
            ptr = ___arg1 ;
            ___result_voidstar = ptr->next ;
            "
            ))

(def xmlAttr->children
  (c-lambda (xmlAttrPtr) xmlAttrPtr
            "
            xmlAttrPtr ptr ;
            ptr = ___arg1 ;
            ___result_voidstar = ptr->children ;
            "
            ))

(def xmlAttr->name
  (c-lambda (xmlAttrPtr) xmlChar*
            "
            xmlAttrPtr ptr ;
            ptr = ___arg1 ;
            ___result = ptr->name ;
            "
            ))

(def xmlAttr->type
  (c-lambda (xmlAttrPtr) int
            "
            xmlAttrPtr ptr ;
            ptr = ___arg1 ;
            ___result = ptr->type ;
            "
            ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        High Level Functions               ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def xml/node-name      (fnil xmlNode->name))
;;(def xml/node-content   (fnil xmlNodeGetContent))
(def xml/node-type      (fnil xmlNode->type))
(def xml/node-next      (fnil xmlNode->next))
(def xml/node-child     (fnil xmlNode->children))
(def xml/attr-next      (fnil xmlAttr->next))
(def xml/attr-name      (fnil xmlAttr->name))



(defn xml/node-count-ElementNodes (node)
  (count-until xml/node-next
               nil?
               (xml/node-child node)
               (fn [n] (= 1 (xml/node-type n)))
               ))


(defn xml/node-attr (node)
  "Returns all XML-node attributes"

  (letc

   [attr0  (bind-nil xmlNode->properties node)]

   (if (not-nil? attr0)

       (map
        (fn [a] (letc [attr (xml/attr-name a)]
                      (list attr (xmlGetProp node attr))
                      ))
        (iterate-until xml/attr-next nil? attr0))

       '()
       )))

(defn xml/node-content (node)
  (if (and
       (equal? 1 (xml/node-type node))
       (zero? (xml/node-count-ElementNodes node)))

      (bind-nil xmlNodeGetContent node)
      nil
      ))

(defn xml/node-siblings (node)
  "Return all simblings nodes of current node"
  (filter (fn [n] (= 1 (xmlNode->type n)))
          (iterate-until xmlNode->next nil? node)))

(defn xml/node-children (node)
  (filter (fn [n] (= 1 (xml/node-type n)))
          (iterate-until xml/node-next
                         nil?
                         (xml/node-child node))))

(defn xml/node->tree (node)

  (letc

   [
    tag       (xml/node-name node)
    attr      (xml/node-attr node)
    content   (xml/node-content node)
    children  (xml/node-children node)
    ]
   (vector
    (list tag:  tag)
    (list attr: attr)
    (list val:  content)
    (list nodes: (map xml/node->tree children))
    )))

(defn xml/file->tree (filename)
  "
  Parse a xml file and returns a S expression
  representing the xml structure of the file.
  "
  (letc
   [
    doc  (bind-nil xmlParseFile filename)
    root (bind-nil xmlDocGetRootElement doc)
    tree (bind-nil xml/node->tree root)

    ]
   (bind-nil xmlFreeDoc doc)
   (xmlCleanupParser)
   tree
   ))


(defn xml/tree->nodes (tree)
  (alist-get tree nodes:))



(defn xml/tree-tag (tree)
  (cadr  (vector-ref tree 0)))

(defn xml/tree-attr (tree)
  (cadr  (vector-ref tree 1)))

(defn xml/tree-val (tree)
  (cadr  (vector-ref tree 2)))

(defn xml/tree-nodes (tree)
  (cadr (vector-ref tree 3)))





(defn xml/tree->step (tree step)
  "Tree iterator "

  (if (nil? tree)
      nil
      (match step

             (next   (xml/tree-nodes tree))
             (first  (first tree))
             (fnext  (xml/tree-nodes (first tree)))

             ;;; Retrive all attributes
             (attrs  (map (fn [xs] (xml/tree-attr xs)) tree))

             ((stp val)  (match stp

                                (nth  (list-ref tree val))

                                (tag? (filter
                                       (fn [xs] (equal? val (xml/tree-tag xs) ))
                                       tree
                                       ))

                                (tag= (find
                                       (fn [xs] (equal? val (xml/tree-tag xs) ))
                                       tree
                                       ))

                                (attr?
                                 (map

                                  (fn [xs] (alist-get (xml/tree-attr xs) val))

                                  tree
                                  ))

                                (attrs?
                                 (map
                                  (fn [xs]
                                      (map (fn [attr]
                                               (alist-get (xml/tree-attr xs) attr)) val ))
                                  tree
                                  ))

                                ))

             )))

;; (xml/tree->path data '[next (tag= "Cube") next first next])

(defn xml/tree->path (tree path)
  "Tree path query language"
  (reduce xml/tree->step path tree))

(defn xml/xpath-eval (xmldoc xpath)
  "Evaluates xpath expression"
  (letc

   [
    context   (bind-nil xmlXPathNewContext xmldoc)
    result    (bind-nil (fn [c] (xmlXPathEvalExpression xpath c)) context)

    nodeset   (bind-nil xmlXPathObject->nodesetval result)

    nodetab   (bind-nil xmlNodeSet->nodeTab nodeset)
    n         (bind-nil xmlNodeSet->nodeNr nodeset 0)

    output    (collect-times
               n
               (fn [i]
                   (xmlNodeListGetString xmldoc
                     (nodeTab->get nodetab i) 1)))

    ]


   (begin
     (bind-nil xmlXPathFreeContext context)
     (bind-nil xmlXPathFreeObject result)

     output
     )
   ))
