#include <sourcemod>
#include <DateTime>
#include <TimeSpan>

public void OnPluginStart()
{
    DateTime hDateTimeFuture = new DateTime(DateTime_Now);
    hDateTimeFuture += TimeSpan.FromHours(1);

    CreateTimer(1.0, Timer_PrintDateTime, hDateTimeFuture, TIMER_REPEAT);
}

public Action Timer_PrintDateTime(Handle hTimer, DateTime hDateTimeFuture)
{
    DateTime hDate = DateTime.Subtract(hDateTimeFuture, DateTime.Now());

    // The parsing date is one hour into the future
    DateTime hDate2 = DateTime.Subtract(DateTime.Parse("2022-05-02 01:33:52"), DateTime.Now());

    PrintToServer("hDate: %.2f", hDate.TotalMinutes);
    PrintToServer("hDate2: %.2f", hDate2.TotalMinutes);

    // Output:

    // hDate: 59.98
    // hDate2: 180.55

    return Plugin_Continue;
}