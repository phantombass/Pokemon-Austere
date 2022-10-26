def pbTimeChanger
  $time_changer == 0 ? pbMessage(_INTL("Switch to what Time?\\ch[34,4,Night,Reset,Cancel]")) : pbMessage(_INTL("Switch to what Time?\\ch[34,4,Day,Reset,Cancel]"))
  t = $game_variables[34]
  $ret = 0
  case t
  when 0
    SetTime.stopped = true
    $time_changer += 1
    $time_changer = 0 if $time_changer >= TIME_CHANGE.size
    time = TIME_CHANGE[$time_changer]
    SetTime.set(Time.local(pbGetTimeNow.year,pbGetTimeNow.mon,pbGetTimeNow.day,time,0,0))
    $time_changer == 0 ? pbMessage(_INTL("Time set to Day.")) : pbMessage(_INTL("Time set to Night."))
    $time_update = true
  when 1
    SetTime.clear
    pbMessage(_INTL("Time reset."))
    $time_changer = PBDayNight.isNight? ? 1 : 0
    $time_update = true
  when -1,3,4
    pbPlayCloseMenuSE
    $time_update = false
  end
end

TIME_CHANGE = [10,20]
$time_changer = PBDayNight.isNight? ? 1 : 0
$time_update = false
