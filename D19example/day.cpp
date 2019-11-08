#include<stdio.h>
 int main (){
 	int ngay,thang,nam,songaytrongthang;
 	scanf("%d %d %d",&ngay,&thang,&nam);
 	switch(thang)
 	{
		case 1: case 3: case 5: case 7: case 8: case 10: case 12:
		    songaytrongthang=31;
		break;
		case 4: case 6: case 9: case 11:
			songaytrongthang=30;
		break;
		case 2:
			if(nam%4==0 && nam%100!=0 || nam%400==0)
				songaytrongthang=29;
			else
				songaytrongthang=28;
    }
    //Tinh ngay truoc do
    int prev_day=ngay, prev_month=thang,prev_year=nam;
    // 3 biến phía trên sẽ là những gì em in ra trong phần "hôm qua"
	if(ngay==1) //nếu ngày = 1
    {
		if (thang == 1) // nếu ngày và tháng = 1
        {
            prev_year--; // năm trừ đi 1 và tháng = 12
            prev_month=12;
        }
        else prev_month--; // nếu tháng không phải 1 thì giảm tháng xuóng
        switch(prev_month) // tính số ngày của tháng trước đó
        {
            case 1: case 3: case 5: case 7: case 8: case 10: case 12:
                prev_day = 31;
            break;
            case 4: case 6: case 9: case 11:
                prev_day=30;
            break;
            case 2:
                if(nam%4==0 && nam%100!=0 || nam%400==0)
                    prev_day=29;
                else prev_day=28;
        }
	}
	else prev_day--; // nếu ngày không = 1 thì giảm biến ngày in ra đi 1
    printf("Ngay truoc do la %d/%d/%d",prev_day,prev_month,prev_year); // in ra thôi
	//Tinh ngay sau
    int next_day = ngay, next_month=thang, next_year=nam;
    if(ngay==songaytrongthang)
    {
        next_day=1;
        if(thang==12)
        {
            next_month=1;
            next_year++;
        }
        else next_month++;
    }else next_day++;
    printf("\nNgay mai la %d/%d/%d",next_day,next_month,next_year);
    return 0;
}
//
