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

;; (insert-if-short x lst n) -> list or atom
;; Purpose: put x at the front of every list (at every level of
;;          nesting, including lst itself) whose length is less
;;          than n. Length is the number of top-level elements of
;;          the ORIGINAL list, before anything is inserted.
;;          A list is anything where (or (null? e) (pair? e)) is
;;          true, so () is a list too. Atoms come back unchanged.
;; Recursive reading:
;;   - If lst is an atom, there is nothing to insert into: the
;;     answer is lst itself.
;;   - If lst is a list (possibly ()):
;;       1. use my-map to apply insert-if-short to each element
;;          -> inner (sublists done, atoms unchanged)
;;       2. if (my-length lst) < n, the answer is (cons x inner);
;;          otherwise the answer is inner.
;;   my-length is taken on lst, not on inner, so the length is
;;   always the original one.
(define (insert-if-short x lst n)
  (if (or (null? lst) (pair? lst))
      (let ((inner (my-map (lambda (e) (insert-if-short x e n)) lst)))
        (if (< (my-length lst) n)
            (cons x inner)
            inner))
      lst))
