#Create a simulator object
set ns [new Simulator]

$ns color 2 red       
$ns rtproto Static     #tell simulator to use static routing

#Open the Trace File
set traceFile [open 1.tr w]
$ns trace-all $traceFile

#Open the NAM trace file
set namFile [open 1.nam w]
$ns namtrace-all $namFile

proc finish {} {
	global ns traceFile namFile
	$ns flush-trace
	close $traceFile
	close $namFile
	#exec awk -f Stats.awk 1.tr &

	exec nam 1.nam & 
	exit 0
}

#Set up 3 nodes
set n(1) [$ns node]
set n(2) [$ns node]
set n(3) [$ns node]

#Set up duplex links
$ns duplex-link $n(1) $n(2) 2Mb 20ms DropTail
$ns duplex-link $n(2) $n(3) 2Mb 20ms DropTail
$ns queue-limit $n(1) $n(2) 10
$ns queue-limit $n(2) $n(3) 10

#aesthitics
#source(udp)
$n(1) shape hexagon
$n(1) color red

#destination(udp)
$n(2) shape square
$n(2) color blue

#Create a UDP agent and attach it to node n(1)
set udp0 [new Agent/UDP]
$ns attach-agent $n(1) $udp0

#Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set PAcketSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Create a null agent (a traffic sink) and attach it to node n(3)
set null0 [new Agent/Null] 
$ns attach-agent $n(3) $null0

#Connect the traffic source with traffic sink and assign flow id color
$ns connect $udp0 $null0
$udp0 set fid_ 2

#sim events
$ns at 0.5 "$cbr0 start"
$ns at 2.0 "$cbr0 stop"
$ns at 2.0 "finish"

$ns run



