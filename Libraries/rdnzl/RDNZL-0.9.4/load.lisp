;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-
;;; $Header: /usr/local/cvsrep/rdnzl_lisp/load.lisp,v 1.17 2006/01/31 16:43:43 edi Exp $

;;; Copyright (c) 2004-2006, Dr. Edmund Weitz.  All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;;; Load this file to compile and load all of RDNZL - see README.txt
;;; and the doc folder for details.

(in-package :cl-user)

(let ((rdnzl-base-directory
        (make-pathname :name nil :type nil :version nil
                       :defaults (parse-namestring *load-truename*))))
  (let (must-compile)
    (dolist (file '("packages"
                    "specials"
                    "util"
                    #+:allegro "port-acl"
                    #+:cormanlisp "port-ccl"
                    #+:clisp "port-clisp"
                    #+:lispworks "port-lw"
                    #+:sbcl "port-sbcl"
                    "ffi"
                    "container"
                    "reader"
                    "arrays"
                    "adapter"
                    "import"
                    "direct"))
      (let ((pathname (make-pathname :name file :type "lisp" :version nil
                                     :defaults rdnzl-base-directory)))
        (let ((compiled-pathname (compile-file-pathname pathname)))
          (unless (and (not must-compile)
                       (probe-file compiled-pathname)
                       (< (file-write-date pathname)
                          (file-write-date compiled-pathname)))
            (setq must-compile t)
            (compile-file pathname))
          (setq pathname compiled-pathname))
        (load pathname)))))

