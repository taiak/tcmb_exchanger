# TCMB EXCHANGER
Calculates the exchange rates over the daily exchange rates given by the [TCMB(Türkiye Cumhuriyet Merkez Bankası) link.](https://www.tcmb.gov.tr/kurlar/today.xml).


~~~ruby
require 'tcmb_exchanger'

t = TCMB_exchanger.new
t.process # fetch and calculate values

t.exchanges.keys # show all exchange values

t.exchanges['USD']['for_buy'] # get forex buy value of usd
t.usd.for_buy                 # functional way to get forex buy value of usd 
~~~
