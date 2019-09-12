set ns [new Simulator]

$ns color 2 red       
$ns rtproto Static     #tell simulator to use static routing

#Open the Trace File
set traceFile [open 2.tr w]
$ns trace-all $traceFile

#Open the NAM trace file
set namFile [open 2.nam w]
$ns namtrace-all $namFile

proc finish {} {
	global ns traceFile namFile
	$ns flush-trace
	close $traceFile
	close $namFile
	exec awk -f Stats2.awk 2.tr &

	exec nam 2.nam & 
	exit 0
}

#Set up 4 nodes
for {set i 0} {$i < 4} {incr i} {
 	set n($i) [$ns node]
 }
 
#Set up duplex links
$ns duplex-link $n(0) $n(2) 0.5Mb 20ms DropTail
$ns duplex-link $n(2) $n(2) 0.5Mb 20ms DropTail
$ns duplex-link $n(2) $n(3) 0.5Mb 20ms DropTail

$ns queue-limit $n(0) $n(2) 10

#Create a TCP agent and attach it to node n(0)
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0
set sink0 [new Agent/TCP]
$ns attach-agent $n(3) $sink0
$ns connect $tcp0 $sink0

#Attach TELNET
set telnet [new Application/Telnet]
$telnet attach-agent $tcp0
$telnet set interval 0

#Create a TCP agent and attach it to node n(1)
set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1
set sink1 [new Agent/TCP]
$ns attach-agent $n(3) $sink1
$ns connect $tcp1 $sink1

set ftp [new Application/FTP]
$ftp attach-agent $tcp1
$ftp set type_

#Schedule events
$ns at 0.5 "$telnet start"
$ns at 0.6 "$ftp start"
$ns at 24.5 "$telnet stop"
$ns at 24.5 "$ftp stop"
$ns at 25.0 "finish"
	
$ns run
