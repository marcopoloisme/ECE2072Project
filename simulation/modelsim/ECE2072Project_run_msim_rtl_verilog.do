transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Exam/Desktop/uni/2026/ECE2072/Ece2072Project {C:/Users/Exam/Desktop/uni/2026/ECE2072/Ece2072Project/mux_10_to_1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Exam/Desktop/uni/2026/ECE2072/Ece2072Project {C:/Users/Exam/Desktop/uni/2026/ECE2072/Ece2072Project/mux_10_to_1_tb.v}

