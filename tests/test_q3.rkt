;; tests/test_q3.rkt -- tests for S1 (Binary Tree Traversals)
;; This file has NO #lang line. It is appended to code/29_q3.rkt,
;; the same way the grader adds its calls. Run it from the repo root with:
;;   Get-Content code\29_q3.rkt, tests\test_q3.rkt | Set-Content -Encoding ascii tmp.rkt
;;   racket tmp.rkt
;;   Remove-Item tmp.rkt
;; Each call has its expected output in the comment above it.

;; ---------------------------------------------------------------
;; Trees from the assignment
;; ---------------------------------------------------------------
(define t1 '(4 (2 (1 () ()) (3 () ()))
               (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

;; ---------------------------------------------------------------
;; Our own edge-case trees
;; ---------------------------------------------------------------
;; single node: the smallest non-empty tree
(define single '(9 () ()))
;; chain leaning left (mirror of t2)
(define left-chain '(3 (2 (1 () ()) ()) ()))
;; node with only a left child
(define left-only '(7 (6 () ()) ()))
;; unbalanced tree with mixed depths
;;          5
;;        /   \
;;       3     8
;;      / \     \
;;     1   4     9
;;      \
;;       2
(define unbalanced '(5 (3 (1 () (2 () ())) (4 () ()))
                       (8 () (9 () ()))))
;; numbers and symbols mixed as values
(define mixed '(x (1 () ()) (y () (2 () ()))))

;; ===============================================================
;; S1.a  print-inorder
;; ===============================================================
;; expected: (1 2 3 4 5 6 7)
(print-inorder t1)
;; expected: (1 2 3)
(print-inorder t2)
;; expected: (b a c)
(print-inorder t3)
;; expected: ()
(print-inorder '())
;; expected: (9)
(print-inorder single)
;; expected: (1 2 3)
(print-inorder left-chain)
;; expected: (6 7)
(print-inorder left-only)
;; expected: (1 2 3 4 5 8 9)
(print-inorder unbalanced)
;; expected: (1 x y 2)
(print-inorder mixed)

;; ===============================================================
;; S1.b  print-all-traversals  (inorder / preorder / postorder)
;; ===============================================================
;; expected:
;; (1 2 3 4 5 6 7)
;; (4 2 1 3 6 5 7)
;; (1 3 2 5 7 6 4)
(print-all-traversals t1)
;; expected:
;; (1 2 3)
;; (1 2 3)
;; (3 2 1)
(print-all-traversals t2)
;; expected:
;; (b a c)
;; (a b c)
;; (b c a)
(print-all-traversals t3)
;; expected:
;; ()
;; ()
;; ()
(print-all-traversals '())
;; expected:
;; (9)
;; (9)
;; (9)
(print-all-traversals single)
;; expected:
;; (1 2 3)
;; (3 2 1)
;; (1 2 3)
(print-all-traversals left-chain)
;; expected:
;; (6 7)
;; (7 6)
;; (6 7)
(print-all-traversals left-only)
;; expected:
;; (1 2 3 4 5 8 9)
;; (5 3 1 2 4 8 9)
;; (2 1 4 3 9 8 5)
(print-all-traversals unbalanced)
;; expected:
;; (1 x y 2)
;; (x 1 y 2)
;; (1 2 y x)
(print-all-traversals mixed)

;; ===============================================================
;; S1.c  print-height-and-leaves  (height leaf-count)
;; ===============================================================
;; expected: (3 4)
(print-height-and-leaves t1)
;; expected: (3 1)
(print-height-and-leaves t2)
;; expected: (2 2)
(print-height-and-leaves t3)
;; expected: (0 0)
(print-height-and-leaves '())
;; expected: (1 1)   -- a single node is a leaf
(print-height-and-leaves single)
;; expected: (3 1)
(print-height-and-leaves left-chain)
;; expected: (2 1)   -- 7 has one empty child but is NOT a leaf
(print-height-and-leaves left-only)
;; expected: (4 3)   -- leaves are 2, 4, 9
(print-height-and-leaves unbalanced)
;; expected: (3 2)   -- leaves are 1, 2
(print-height-and-leaves mixed)