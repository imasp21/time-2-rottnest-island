## Program name: Travel Time to Rottnest Island
## Author: Arjun Panicker
## University: University of Western Australia
## Assumptions : Example ./RtnstTravelTime.sh -31.968002, 115.795795




cc -std=c99 -Wall -Werror -o haversine haversine.c -lm
rot_lat=-31.995682
rot_log=115.541487
dst2rotnest=`./haversine $1 $2 $rot_lat $rot_log`
echo Distance to Rottnest from $1 $2 is $dst2rotnest m

function CFTL(){  #Checks if user is on fremantle line or not

`cat FTL| cut -d, -f 2,3 > ftl_location`
for lines in `cat ftl_location`
do
	temp_lat=` echo $lines | cut -d, -f1`
	temp_log=` echo $lines | cut -d, -f2`
	dst=`./haversine $1 $2 $temp_lat $temp_log`
	num=`echo "scale=5; $dst / 5000 * 60" | bc`
	dst2time=$(awk  'BEGIN { rounded = sprintf("%.0f", '$num'); print rounded }')
	if [[ $dst -lt 1000 ]] || [[ $dst2time -lt 20 ]]
	then
		echo $dst,$temp_lat,$temp_log >> stn_ftl
		flag=1
	fi
done
if [[ $flag -ne 1 ]]
then
	echo Nearest station on Fremantle Train Line is: NONE
else

	temp=`cat stn_ftl | sort -n -k1 | head -n 1| cut -d, -f2`
	echo Nearest station on Fremantle Train Line is: $(grep -e $temp < FTL | cut -d, -f1)
	rm stn_ftl
	flagFTL=1
fi
}

function TrainStn(){ #Function to calculate distance, stations and time taken for the trip.

	awk -F, '$1==0' stops.txt | grep ,Rail | cut -d, -f 7,8 > rail.txt
for lines in `cat rail.txt`
do
	temp_lat=` echo $lines | cut -d, -f1`
	temp_log=` echo $lines | cut -d, -f2`
	dst=`./haversine $1 $2 $temp_lat $temp_log`
	num=`echo "scale=5; $dst / 5000 * 60" | bc`
	dst2time=$(awk  'BEGIN { rounded = sprintf("%.0f", '$num'); print rounded }')
	if [[ $dst -lt 1000 ]] || [[ $dst2time -lt 20 ]]
	then
		echo $dst,$temp_lat,$temp_log,$dst2time >> nearesttrain  #File for nearest train stations
		flag=1
	fi
done
if [[ $flag -ne 1 ]]
then
	echo No train stations nearby. #End program
else

	temp2=`cat nearesttrain | sort -n -k1 | head -n 1| cut -d, -f2`
	temp4=`cat nearesttrain | sort -n -k1 | head -n 1| cut -d, -f3`
	temp3=`grep -e $temp2 < stops.txt | cut -d, -f5`
	nearest_station=$(grep -e $temp2 < stops.txt | cut -d, -f5)
	echo Nearest station entrance to you is: $nearest_station
	dst2time=`cat nearesttrain | sort -n -k1 | head -n 1| cut -d, -f4`
	rm nearesttrain
	stp_id=`awk -F, '$1==0' stops.txt| egrep "($temp3)"  | cut -d, -f 3`
	if [[ $stp_id -ge 99801 ]] &&  [[ $stp_id -le 99902 ]];then					####
		echo Closest Traine line : Joondalup Butler Line,Stop ID: $stp_id			  ##
	elif [[ $stp_id -ge 99421 ]] &&  [[ $stp_id -le 99532 ]]; then				####
		echo Closest Traine line : Midland Line,Stop ID: $stp_id					  ##
	elif [[ $stp_id -ge 99601 ]] &&  [[ $stp_id -le 99732 ]]; then				####	Loop to find out which stations are near by
		echo Closest Traine line : Mandurah Line,Stop ID: $stp_id					  ##
	elif [[ $stp_id -ge 99011 ]] &&  [[ $stp_id -le 99192 ]]; then				####
		echo Closest Traine line : Armadale Line,Stop ID: $stp_id					  ##
	elif [[ $stp_id -ge 99201 ]] &&  [[ $stp_id -le 99351 ]]; then				####
		echo Stop ID : $stp_id
	else
		echo No train lines near by.
	fi

dte_hh=`echo $(date +"%H")`
if [ $dte_hh -eq 08 ]
then
	dte_hh=8
fi
if [ $dte_hh -eq 0 ]
then
	dte_hh=9
fi
dte_hh_=`echo $(($dte_hh+1))`
dte_mm=`echo $(date +"%M")`
if [ $dte_mm -eq 08 ]
then
	dte_mm=8
fi
if [ $dte_mm -eq 09 ]
then
	dte_mm=9
fi
dte_mm=$((dte_mm+dst2time))
dte_mm_og=$((dte_mm-dst2time))

`grep ",$stp_id" stop_times.txt | grep -e ",$dte_hh:" -e ",$dte_hh_:" | cut -d, -f3  | cut -d':' -f2 | sort -u > temp5`
t3=`cat temp5 |head -n 1`
for i in `cat temp5`
do
	t1=`echo $i | cut -d':' -f1`
	t2=`echo $i | cut -d':' -f2`
	if [ $dte_mm -le $t2 ]
	then
		echo $i >> time_temp
		flag_T=1
	fi
done
if [[ $flag_T -ne 1 ]]
then
		echo $t3 >> time_temp
		let	dte_hh=dte_hh_
fi

if [[ $flagFTL -ne 1 ]]
then
	nxt_train_time=`cat time_temp | sort -k2 |head -n 1| cut -d':' -f2`
	echo Time to reach the nearest station from $1 $2 is : $dst2time mins
	echo Current Time : $(date +"%H:%M"), Next Train to Perth Stn Departs at: $dte_hh:$nxt_train_time
	rm time_temp
else
	nxt_train_time=`cat time_temp | sort -k2 |head -n 1| cut -d':' -f2`
	echo Time to reach the reach nearest station from $1 $2 is : $dst2time mins
	echo Current Time : $(date +"%H:%M"), Next Train Departs at: $dte_hh:$nxt_train_time
	rm time_temp
fi
if [[ $flagFTL -ne 1 ]]
then
	updatedDist=`./haversine $temp2 $temp4 -32.0520422222221980 115.745073333333`
	num=`echo "scale=3; $updatedDist / 1667 + 57" | bc`
	num=$(awk  'BEGIN { rounded = sprintf("%.0f", '$num'); print rounded }')
	if [ $num -gt 59 ]
	then
	num_hr=$((num/60))
	num_mn=$((num%60))
	echo Approx Travel time from $nearest_station to Fremantle Station is $num_hr hr $num_mn mins including transit time.
	else
		echo Approx Travel time from $nearest_station to Fremantle Station is $num mins including transit time.
	fi
else
	updatedDist=`./haversine $temp2 $temp4 -32.0520422222221980 115.745073333333`
	num=`echo "scale=5; $updatedDist / 1667 + 9" | bc`
	num=$(awk  'BEGIN { rounded = sprintf("%.0f", '$num'); print rounded }')
	if [ $num -gt 59 ]
	then
	num_hr=$((num/60))
	num_mn=$((num%60))
	echo Approx Travel time from $nearest_station to Fremantle Station is $num_hr hr $num_mn mins including transit time.
	else
		echo Approx Travel time from $nearest_station to Fremantle Station is $num mins including transit time.
	fi

fi
	if [[ $dte_hh -gt 5 ]] && [[ $dte_hh -le 7 ]];
	then
		echo Next Ferry to Rottnest at 07:30 AM
	elif [[ $dte_hh -gt 7 ]] && [[ $dte_hh -le 9 ]];
	then
		echo Next Ferry to Rottnest at 09:45 AM
	elif [[ $dte_hh -gt 9 ]] && [[ $dte_hh -le 10 ]];
	then
		echo Next Ferry to Rottnest at 10:15 AM
	elif [[ $dte_hh -gt 10 ]] && [[ $dte_hh -le 15 ]];
	then
		echo Next Ferry to Rottnest at 15:30 PM
	else
		echo No Ferry Available!
	fi
fi
}


CFTL $1 $2
TrainStn $1 $2
rm ftl_location temp5 rail.txt
