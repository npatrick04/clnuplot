(in-package #:clnuplot)

(defparameter *gnuplot-home* "/usr/bin/gnuplot")

(defmethod write-plot ((plot gnuplot) (style (eql :pdf)))
  (write-plot plot :postscript)
  (execute-plot plot))

(defun execute-plot (plot) 
  (if (probe-file (fullpath plot ".ps"))
    (trivial-shell:shell-command 
     (format nil "export PATH=/usr/bin:/usr/local/bin:$PATH; cd ~A; ~A ~A"
             (pathname-directory (fullpath plot ".ps"))
             *gnuplot-home*
             (pathname-name+type (fullpath plot ".ps"))))
    (error "Plot command file ~A does not exist" (fullpath plot ".ps"))))

#+digitool
(defmethod open-plot-in-window (plot)
  (write-plot plot :pdf)
  (let ((pdf (make-pathname :type "pdf"
                            :defaults (fullpath plot))))
    (if (probe-file pdf)
      (ccl::open-image-window pdf))))
  
 
