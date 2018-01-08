#lang rosette 
 
(require "../cosette.rkt" "../sql.rkt" "../evaluator.rkt" "../syntax.rkt") 
 
(provide ros-instance)
 
(current-bitwidth #f)
 
(define-symbolic div_ (~> integer? integer? integer?))
 
(define t-info (table-info "t" (list "k0" "c1" "f1_a0" "f2_a0" "f0_c0" "f1_c0" "f0_c1" "f1_c2" "f2_c3")))
 
(define account-info (table-info "account" (list "acctno" "type" "balance")))
 
(define bonus-info (table-info "bonus" (list "ename" "job" "sal" "comm")))
 
(define dept-info (table-info "dept" (list "deptno" "name")))
 
(define emp-info (table-info "emp" (list "empno" "ename" "job" "mgr" "hiredate" "comm" "sal" "deptno" "slacker")))
 

(define (q1 tables) 
  (SELECT (VALS "dept.deptno" "dept.name") 
  FROM (JOIN (NAMED (RENAME (list-ref tables 3) "dept")) (AS (SELECT (VALS "emp.deptno") 
 FROM (NAMED (RENAME (list-ref tables 4) "emp")) 
 WHERE (BINOP "emp.sal" > 100) GROUP-BY (list "emp.deptno") 
 HAVING (TRUE)) ["t1" (list "deptno")])) 
  WHERE (BINOP "dept.deptno" = "t1.deptno")))

(define (q2 tables) 
  (SELECT (VALS "dept0.deptno" "dept0.name" "t4.deptno") 
  FROM (JOIN (NAMED (RENAME (list-ref tables 3) "dept0")) (AS (SELECT (VALS "emp0.deptno") 
  FROM (NAMED (RENAME (list-ref tables 4) "emp0")) 
  WHERE (BINOP "emp0.sal" > 100)) ["t4" (list "deptno")])) 
  WHERE (BINOP "dept0.deptno" = "t4.deptno")))


(define ros-instance (list q1 q2 (list t-info account-info bonus-info dept-info emp-info))) 