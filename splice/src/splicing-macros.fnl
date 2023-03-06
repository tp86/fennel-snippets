(import-macros {: declare : define} :declare)
(local {: view} (require :fennel))

(local splicing-symbol (sym "&splice"))
(declare splice-iforms)
(declare splice-forms)

(fn splice [form ?enclosing]
  (if
    (list? form)
    (do
      (var enclosing (list))
      (let [[first-form] form]
        (when (= splicing-symbol first-form)
          (table.remove form 1)
          (set enclosing (or ?enclosing (list `values)))))
      (splice-iforms form enclosing))

    (sequence? form)
    (splice-iforms form [])

    (table? form)
    (splice-forms form {})

    form))

(define splice-iforms
  (fn [form enclosing]
    (each [_ subform (ipairs form)]
      (let [spliced [(splice subform enclosing)]]
        (each [_ subform (ipairs spliced)]
          (when (not= subform enclosing)
            (table.insert enclosing subform)))))
    enclosing))

(define splice-forms
  (fn [form enclosing]
    (each [keyform valueform (pairs form)]
      (let [spliced-key (splice keyform enclosing)
            spliced-value (splice valueform enclosing)]
        (tset enclosing spliced-key spliced-value)))
    enclosing))

(fn with-splicing [form]
  (splice form))

{: with-splicing}
