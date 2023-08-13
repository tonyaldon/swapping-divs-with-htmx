;; HTMX DEMO FOR A FRIEND

;; Start a browser-sync server:
;;
;;     $ browser-sync start -s -w --files "*"

(require 'jack)
(let ((index.html
       (jack-html
        "<!DOCTYPE html>"
        `(:html (@ :lang"en")
          (:head
           (:style "table, th, td {border:1px solid grey;}
                    #container {width:200px; height:100px;
                                background-color: orange;
                                margin-top: 1em;
                                padding-top: 1em;}")
           (:script (@ :src "https://unpkg.com/htmx.org@1.9.4")))
          (:body
           (:h1 "Swapping divs with "
            (:a (@ :href "https://htmx.org") "https://htmx.org"))
           (:div
            (@ :hx-get "/foo" :hx-target "#container")
            "foo")
           (:div (@ :hx-get "/bar" :hx-target "#container")
            "bar")
           (:div (@ :id "container"))))))
      (foo/index.html
       (jack-html
        '(:ul
          (:li "I've been swapped")
          (:li "by foo")
          (:li "thanks to htmx"))))
      (bar/index.html
       (jack-html
        '(:table
          (:tr
           (:th "")
           (:th "I've been swapped") )
          (:tr
           (:td "by")
           (:td "bar") )
          (:tr
           (:td "thanks to")
           (:td "htmx"))))))
  (make-directory "foo" t)
  (make-directory "bar" t)
  (dolist (page '(index.html foo/index.html bar/index.html))
    (let* ((page-str (symbol-name page)))
      (with-temp-file page-str (insert (eval page))))))

;; need `prettier' utility installed
(dolist (page '("index.html" "foo/index.html" "bar/index.html"))
  (call-process-shell-command
   (concat "prettier --write " page)
   nil 0))
