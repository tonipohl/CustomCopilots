# Flow Helpers

## Calculate days from today

~~~
div(
    sub(
        ticks(utcNow()), 
        ticks(if(equals(item()?['lastActivityDate'], ''), addDays(utcNow(), 1), item()?['lastActivityDate']))
    ), 
    864000000000
)
~~~

## inUse

~~~
 if(
    and(
        greaterOrEquals(
            div(
                sub(
                    ticks(utcNow()), 
                    ticks(if(equals(item()?['lastActivityDate'], ''), addDays(utcNow(), 1), item()?['lastActivityDate']))
                ), 
                864000000000
            ), 
            0
        ), 
        lessOrEquals(
            div(
                sub(
                    ticks(utcNow()), 
                    ticks(if(equals(item()?['lastActivityDate'], ''), addDays(utcNow(), 1), item()?['lastActivityDate']))
                ), 
                864000000000
            ), 
            int(variables('config')?['inactivitywarning'])
        )
    ), 
	true,
    false
)
~~~
