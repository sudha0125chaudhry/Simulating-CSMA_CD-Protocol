#code:
#initialisation
set ns [new Simulator]


#Define different colors for data flows
$ns color 1 Green
$ns color 2 Orange


#open the NAM trace file
set nf [open csma.nam w]
$ns namtrace-all $nf


#open the trace file
set nd [open  csma.tr  w]
$ns trace-all $nd


#define a finish procedure
proc finish {} {
	global ns nf nd
	$ns flush-trace
	close $nf
	close $nd
	exec nam csma.nam &
	exit 0
}


#create 12 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]


$n0 color purple
$n1 color purple
$n2 color purple
$n3 color purple
$n4 color purple
$n5 color purple
$n6 color purple
$n7 color purple
$n8 color purple
$n9 color purple
$n10 color purple
$n11 color purple


#Create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n0 2Mb 10ms DropTail

$ns duplex-link $n4 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
$ns duplex-link $n7 $n8 2Mb 10ms DropTail
$ns duplex-link $n8 $n4 2Mb 10ms DropTail

$ns duplex-link $n5 $n9 2Mb 10ms DropTail
$ns duplex-link $n9 $n10 2Mb 10ms DropTail
$ns duplex-link $n10 $n11 2Mb 10ms DropTail
$ns duplex-link $n11 $n5 2Mb 10ms DropTail

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n3 2Mb 10ms DropTail

$ns duplex-link $n4 $n7 2Mb 10ms DropTail
$ns duplex-link $n6 $n8 2Mb 10ms DropTail

$ns duplex-link $n5 $n10 2Mb 10ms DropTail
$ns duplex-link $n9 $n11 2Mb 10ms DropTail


set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]


#setup a tcp connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1


#setup a FTP over a tcp connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp


#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2


#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 500


$ns at 4.0 "$ftp start"
$ns at 5.0 "$ftp stop"

$ns at 4.0 "$cbr start"
$ns at 5.0 "$cbr stop"

$ns at 5.5 "finish"
$ns run


