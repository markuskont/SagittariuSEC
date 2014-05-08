#!/usr/bin/perl


$host = "myhost";
$prog = "mytest[1234]";
$count = 300000;
if (!open(SYSLOG, " | nc 192.168.0.28 514")) {
	die "Can't connect to syslog server: $@\n";
}
for ($i = 0; $i < $count; ++$i) {
	$pri = $i % 192;
	$facility = int($pri / 8);
	$severity = $pri % 8;
	if (!$pri) {
		$time = scalar(localtime());
		substr($time, 0, 4) = "";
		substr($time, 15) = "";
	}
	$msg = "<$pri>$time $host $prog: message $i, facility $facility, severity $severity";
	print SYSLOG $msg, "\n";
}
$msg = "<$pri>$time $host $prog: DONE";
print SYSLOG $msg, "\n";
close(SYSLOG);