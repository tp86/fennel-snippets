(local {: view} (require :fennel))

(var splice-subforms nil)

(fn splice [form ?enclosing]
  (if
    (list? form)
    (do
      (var enclosing (list))
      (let [[symbol] form]
        (when (= (sym :&^) symbol)
          (table.remove form 1)
          (set enclosing (or ?enclosing (list `values)))))
      (splice-subforms form enclosing))

    (sequence? form)
    (splice-subforms form [])

    form))

(set splice-subforms
  (fn [form enclosing]
    (each [_ subform (ipairs form)]
      (let [spliced [(splice subform enclosing)]]
        (each [_ subform (ipairs spliced)]
          (when (not= subform enclosing)
            (table.insert enclosing subform)))))
    enclosing))

(fn !^ [form]
  (splice form))

{: !^}
