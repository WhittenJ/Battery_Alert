SetBatchLines, -1 ; Determines how fast a script will run (affects CPU utilization). The value -1 means the script will run at it's max speed possible.
SetTitleMatchMode 2
#Persistent ; Keeps script permanently running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force ; Ensures that there is only a single instance of this script running.
#InstallKeybdHook
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Battery charge notification
;
; When the battery is charged, a notification
; will appear to tell the user to remove the charger
;
; When the battery is below 10%, a notification
; will appear to tell the user to plug in the charger
;


percentage := "%"
sleepTime := 60 * 1000 ; Delay in seconds
lowerLimit = 75

Loop ; Loop forever
	{

	; Grab the current data.
	; https://docs.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-system_power_status
	VarSetCapacity(powerstatus, 12) ; 1+1+1+1+4+4
	success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

	acLineStatus := ExtractValue(&powerstatus, 0)			; Charger Connected
	;batteryStatus := ExtractValue(&powerstatus, 1)          ; Battery Charge Status - Not used
	batteryChargePercent := ExtractValue(&powerstatus, 2)	; Battery Charge Level
	;systemStatus := ExtractValue(&powerstatus, 3)           ; System Status - Not used

/*  No one cares about this.
	; Is the battery charged higher than 99%
	if (batteryChargePercent > 99) ; Yes
		{
		if (acLineStatus == 1) ; Only alert if the power lead is connected
			{
			if (batteryChargePercent != 255) ; and if the battery is not disconnected
				{
				output=UNPLUG THE CHARGING CABLE !!!`nBattery Charge Level: %batteryChargePercent%%percentage%
				notifyUser(output)
				}
			}
		}
*/
	; Is the battery charged less than lowerLimit%
	if (batteryChargePercent < lowerLimit) ; Yes
		{
		if (acLineStatus == 0) ; Only alert if the power lead is not connected
			{
			output=PLUG IN THE CHARGING CABLE !!!`nBattery Charge Level: %batteryChargePercent%%percentage%
			notifyUser(output)
			}
		}


	sleep, sleepTime		
	}
Return


; Alert user visually and audibly
notifyUser(message)
	{
	SoundBeep, 1500, 200
	MsgBox, %message%
	}


;Format the value from the structure
ExtractValue(p_address, p_offset)
	{
	loop, 1
		value := 0+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
	return, value
	}
