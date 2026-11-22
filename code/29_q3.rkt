#lang racket/base

;; (inorder-acc tree acc) -> list
;; Purpose: the values of tree in inorder (left, node, right),
;;          placed in front of the list acc.
;; Recursive reading:
;;   - If tree is empty, there is nothing to add: the answer is acc.
;;   - If tree is (v left right):
;;       1. put the inorder of right in front of acc   -> R
;;       2. cons v onto R                              -> (v . R)
;;       3. put the inorder of left in front of that   -> answer
;;   Building from the right end means no append is needed.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) acc)))))

;; (preorder-acc tree acc) -> list
;; Purpose: the values of tree in preorder (node, left, right),
;;          placed in front of the list acc.
;; Recursive reading:
;;   - If tree is empty, the answer is acc.
;;   - If tree is (v left right):
;;       1. put the preorder of right in front of acc  -> R
;;       2. put the preorder of left in front of R     -> L
;;       3. cons v onto L                              -> answer
;;   Pieces are added in reverse order (R, L, v) because the
;;   list is built from the right end.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc (cadr tree)
                          (preorder-acc (caddr tree) acc)))))

;; (postorder-acc tree acc) -> list
;; Purpose: the values of tree in postorder (left, right, node),
;;          placed in front of the list acc.
;; Recursive reading:
;;   - If tree is empty, the answer is acc.
;;   - If tree is (v left right):
;;       1. cons v onto acc                            -> (v . acc)
;;       2. put the postorder of right in front of it  -> R
;;       3. put the postorder of left in front of R    -> answer
;;   Pieces are added in reverse order (v, R, L) because the
;;   list is built from the right end.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree)
                                    (cons (car tree) acc)))))

;; (print-inorder tree) -> prints one line
;; Purpose: print the inorder list of tree, then a newline.
;; Reading: the inorder list of the whole tree is inorder-acc with
;;          nothing after it, i.e. acc = '(). Display it, then newline.
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))