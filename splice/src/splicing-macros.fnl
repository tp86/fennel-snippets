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

(fn with-splicing-old [form]
  (splice form))

(fn with-splicing [form]
  (when (or
          (list? form)
          (table? form))
    (each [subform-idx subform (pairs form)]
      (if (and
            (list? subform)
            (= splicing-symbol (. subform 1)))
        (do
          (table.remove form subform-idx)
          (each [spliced-subform-idx spliced-subform (ipairs subform)]
            (when (< 1 spliced-subform-idx)
              (table.insert form
                            (+ subform-idx (- spliced-subform-idx 2))
                            (with-splicing spliced-subform)))))
        (with-splicing subform))))
  form)

{: with-splicing}
