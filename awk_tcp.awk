#awk file for tcp
BEGIN{

drops = 0;

sim_time = 0;
thr = 0;
total_size = 0;

sum = 0;
recvnum = 0;

}


{

event = $1;
time = $2;
from = $3;
to = $4;
type = $5;
packet_size = $6;
flow_id = $8;
src = $9;
dest = $10;
seq_no = $11;
packet_id = $12;


#for number of packets dropped
if(flow_id == 1 && event == "d")
drops++;


#for throughtput
if(event == "r" && dest == 4.0 && to == 3 && flow_id = 1)
	{
		total_size = total_size + packet_size;
		sim_time = time;
	}

	
#calculate delay 
if(start_time[packet_id] == 0)
	{
		start_time[packet_id] = time;
	}
  
if(event == "r" && type == "cbr") 
	{ 
		end_time[packet_id] = time;  
	}
else 
	{  
		end_time[packet_id] = -1;  
	}
}


END{

for ( i in end_time )
	{
	start = start_time[i];
	end = end_time[i];
	packet_duration = end - start;
	if ( packet_duration > 0 )  
		{
			sum += packet_duration;
       			recvnum++; 
		}
	}
  
	delay=sum/recvnum;

printf("\n---------------------------------------------------------\n")

#for number of packets dropped
printf("Number of Packets Dropped: %d \n", drops);


#for throughtput
thr = (total_size*8)/((sim_time - 1)*1000000);
printf("Throughput of the system: %f \n", thr);


#for delay
printf("Average end to end delay=%.2f\n",delay*1000);

printf("\n---------------------------------------------------------\n")


}
