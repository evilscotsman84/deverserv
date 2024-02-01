Config= Config or {}
--**do not do the run the command for dv when the dv countdown is running!!**--

--cooldown for every dvall
--Minutes
Config.cooldownTimeM= 35
--Seconds
Config.cooldownTimeS= 0

--how much time before the end of the cooldown
--will pop up a timer until the dvall
--Minutes

-- its need to be under cooldownTimeM if 
--cooldownTimeM is 60 then it need to be maximum 59

Config.cooldownAlertM= 10
--Seconds

-- its need to be under cooldownTimeS if 
--cooldownTimeS is 60 then it need to be maximum 59

Config.cooldownAlertS= 0


--here you will decide the command of the manual dv all
Config.dvallCommand="dvall"


--command time to dv
--Minutes
Config.commandTimerM= 0
--Seconds
Config.commandTimerS= 60