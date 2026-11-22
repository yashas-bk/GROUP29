#lang racket/base

;; (my-length lst) -> number
;; Purpose: the number of top-level elements of lst
;;          (a nested list or () counts as one element).
;; Recursive reading:
;;   - Walk down lst with a counter acc that starts at 0.
;;   - If what is left is empty, every element has been counted:
;;     the answer is acc.
;;   - Otherwise the first element adds 1, so continue with
;;     (cdr remaining) and acc + 1.
;;   The recursive call is the last thing done, so this is a loop
;;   (tail recursion) and is safe for lists of 10,000 elements.
(define (my-length lst)
  (let loop ((remaining lst) (acc 0))
    (if (null? remaining)
        acc
        (loop (cdr remaining) (+ acc 1)))))

;; (my-map f lst) -> list
;; Purpose: a new list holding (f e) for each top-level element e
;;          of lst, in the same order.
;; Recursive reading:
;;   - If lst is empty, there is nothing to apply f to: the answer is ().
;;   - If lst is (e . more), the answer is (f e) consed onto
;;     the my-map of more.
;;   The cons happens after the recursive call returns, so the
;;   result comes out in the original order with no reverse.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

;; (make-inserter x len-ok?) -> function
;; Purpose: return a function of one argument. Given a list, it puts
;;          x at the front of every list (at every level of nesting,
;;          including the one it was given) whose ORIGINAL length
;;          satisfies (len-ok? len). A list is anything where
;;          (or (null? e) (pair? e)) is true, so () is a list too.
;;          Atoms come back unchanged.
;; Recursive reading (of the returned function, insert):
;;   - If e is an atom, there is nothing to insert into: the answer
;;     is e itself.
;;   - If e is a list (possibly ()):
;;       1. use my-map to apply insert to each element
;;          -> inner (sublists done, atoms unchanged)
;;       2. if (len-ok? (my-length e)) holds, the answer is
;;          (cons x inner); otherwise the answer is inner.
;;   my-length is taken on e, not on inner, so the length is always
;;   the original one. letrec lets insert call itself on sublists.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (e)
              (if (or (null? e) (pair? e))
                  (let ((inner (my-map insert e)))
                    (if (len-ok? (my-length e))
                        (cons x inner)
                        inner))
                  e))))
    insert))

;; (insert-if-short x lst n) -> list
;; Purpose: put x at the front of every list in lst (at every level,
;;          including lst itself) whose original length is less than n.
;; Recursive reading: no recursion here. It builds an inserter whose
;;   test is (< len n) and applies it to lst; make-inserter does
;;   the recursion over the nesting.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; (print-insert-result) -> nothing useful (prints)
;; Purpose: read x, then lst, then n from standard input, and print
;;          (insert-if-short x lst n) followed by a newline. No prompt
;;          and no other text is printed.
;; Recursive reading: no recursion here. let* makes the three reads
;;   happen in order (x first, then lst, then n); insert-if-short
;;   does the recursion over the nesting.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
