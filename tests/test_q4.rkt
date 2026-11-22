;; tests/test_q4.rkt -- tests for S2 (insert-if-short, make-inserter,
;; print-insert-result)
;; This file has NO #lang line. It is appended to code/29_q4.rkt,
;; the same way the grader adds its calls. Run it from the repo root with:
;;   macOS / Linux:
;;     cat code/29_q4.rkt tests/test_q4.rkt > /tmp/run.rkt && racket /tmp/run.rkt
;;   Windows (PowerShell):
;;     Get-Content code\29_q4.rkt, tests\test_q4.rkt | Set-Content -Encoding ascii run_tmp.rkt
;;     racket run_tmp.rkt
;;     Remove-Item run_tmp.rkt
;; The banned-built-in rules apply only to code/29_q4.rkt, so this file
;; may use equal?, string ports and parameterize.
;; Each check prints PASS or FAIL; the last line is "<passed>/<total> passed".

;; ---------------------------------------------------------------
;; Test helpers
;; ---------------------------------------------------------------

;; (check name actual expected) -> #t or #f
;; Prints "PASS name", or "FAIL name: got <actual>, expected <expected>".
;; Returns #t on pass so the summary can count the results.
(define (check name actual expected)
  (if (equal? actual expected)
      (begin (display "PASS ") (display name) (newline) #t)
      (begin (display "FAIL ") (display name)
             (display ": got ") (write actual)
             (display ", expected ") (write expected)
             (newline) #f)))

;; (run-stdin input) -> string
;; Runs (print-insert-result) with input as its standard input and
;; returns everything it printed, as a string. No real stdin is needed.
(define (run-stdin input)
  (let ((out (open-output-string)))
    (parameterize ((current-input-port (open-input-string input))
                   (current-output-port out))
      (print-insert-result))
    (get-output-string out)))

;; (wrap k v) -> v wrapped in k single-element lists.
;; (wrap 2 '(a)) = '(((a)))
(define (wrap k v)
  (if (= k 0) v (wrap (- k 1) (list v))))

;; (wrap-with-x k v) -> v wrapped k times, with x at the front of each
;; new level: (wrap-with-x 2 '(x a)) = '(x (x (x a)))
(define (wrap-with-x k v)
  (if (= k 0) v (wrap-with-x (- k 1) (list 'x v))))

;; (count-up n) -> the list (0 1 2 ... n-1)
(define (count-up n)
  (let loop ((i n) (acc '()))
    (if (= i 0) acc (loop (- i 1) (cons (- i 1) acc)))))

;; Inputs for the stress tests
(define deep-100 (wrap 99 '(a)))                 ; nesting depth 100
(define deep-100-expected (wrap-with-x 99 '(x a)))
(define flat-10k (count-up 10000))               ; 0 .. 9999

;; ---------------------------------------------------------------
;; All checks, run in order (list evaluates its arguments left to right)
;; ---------------------------------------------------------------
(define results
  (list
   ;; 1. insert-if-short: spec examples
   (check "spec 1: 42 ((1 2) (3 4 5) (6) ()) 3"
          (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)
          '((42 1 2) (3 4 5) (42 6) (42)))
   (check "spec 2: 0 (((1) 2) (3) ((4 5 6) ())) 3"
          (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)
          '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))
   (check "spec 3: 7 () 3"
          (insert-if-short 7 '() 3)
          '(7))
   (check "spec 4: 7 () 0"
          (insert-if-short 7 '() 0)
          '())
   ;; 2. insert-if-short: edge cases
   (check "every level of (((a))) gets x when n=2"
          (insert-if-short 'x '(((a))) 2)
          '(x (x (x a))))
   (check "n=0 leaves ((1) (2 3)) unchanged"
          (insert-if-short 'x '((1) (2 3)) 0)
          '((1) (2 3)))

   ;; 3. make-inserter
   (check "make-inserter y, len > 1"
          ((make-inserter 'y (lambda (len) (> len 1))) '((1) (2 3) 4))
          '(y (1) (y 2 3) 4))
   (check "make-inserter z, len = 0"
          ((make-inserter 'z (lambda (len) (= len 0))) '(() (1) (())))
          '((z) (1) ((z))))

   ;; 4. print-insert-result via stdin (exact text, one newline)
   (check "stdin spec 1"
          (run-stdin "42 ((1 2) (3 4 5) (6) ()) 3")
          "((42 1 2) (3 4 5) (42 6) (42))\n")
   (check "stdin spec 2"
          (run-stdin "0 (((1) 2) (3) ((4 5 6) ())) 3")
          "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
   (check "stdin spec 3"
          (run-stdin "7 () 3")
          "(7)\n")
   (check "stdin spec 4"
          (run-stdin "7 () 0")
          "()\n")
   (check "stdin split over three lines"
          (run-stdin "x\n((1) (2 3))\n2\n")
          "((x 1) (2 3))\n")

   ;; 5. stress tests
   (check "nesting depth 100, n=2: every level gets x"
          (insert-if-short 'x deep-100 2)
          deep-100-expected)
   (check "10,000 elements, n=10001: x added at the front"
          (insert-if-short 'x flat-10k 10001)
          (cons 'x flat-10k))
   (check "10,000 elements, n=10000: unchanged"
          (insert-if-short 'x flat-10k 10000)
          flat-10k)))

;; ---------------------------------------------------------------
;; Summary: "<passed>/<total> passed"
;; ---------------------------------------------------------------
(let loop ((rs results) (passed 0) (total 0))
  (if (null? rs)
      (begin (display passed) (display "/") (display total)
             (display " passed") (newline))
      (loop (cdr rs)
            (if (car rs) (+ passed 1) passed)
            (+ total 1))))
