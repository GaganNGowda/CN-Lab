BEGIN{
	TCPSent = 0;
	TCPReceved = 0;
	TCPLost = 0;
	UDPSent = 0;
	UDPReceved = 0;
	UDPLost = 0;
	totalSent = 0;
	totalReceved = 0;
	totalLost = 0;
}
{
	packetType = $5
	event = $1
	if(packetType == "tcp")
	{
		if(event =="+")
		{
			TCPSent++;
		}
		if(event =="r")
		{
			TCPRecieved++;
		}
		if(event =="d")
		{
			TCPLost++;
		}
	}
	if(packetType == "cbr")
	{
		if(event =="+")
		{
			UDPSent++;
		}
		if(event =="r")
		{
			UDPRecieved++;
		}
		if(event =="d")
		{
			UDPLost++;
		}
	}
}
END{
	totalSent = TCPSent + UDPSent;
	totalLost = TCPLost + UDPLost;
	printf("TCP packets sent : %d\n",TCPSent);
	printf("TCP packets recieved : %d\n",TCPReceved);
	printf("TCP packets dropped : %d\n",TCPLost);
	printf("UDP packets sent : %d\n",UDPSent);
	printf("UDP packets recieved : %d\n",UDPReceved);
	printf("UDP packets dropped : %d\n",UDPLost);
	printf("Total sent : %d\n",totalSent);
	printf("Total Dropped : %d\n",totalLost);
}
