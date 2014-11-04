## Synopsis:

  PDU3VSR_to_graphite.sh will scrape the web interface of a TrippLite PDU with a WebCard that support 
per port metering and ship them off to Graphite, so you can do cool stuff like see how much power that 
blade chassis you might be in charge of is actually using (Sample graphs coming!)

## Requirements:

  bash
  curl
  awk
  nc

## Metrics Published

```
$ ./PDU3VSR_to_graphite.sh 
Default configuration found at /usr/local/etc/PDU3VSR_to_graphite.conf

PDU.pdua1_company_lan.Port1-Server1PS1.usageinA 0.5 1414709192
PDU.pdua1_company_lan.Port1-Server1PS1.usageinW 105 1414709192
PDU.pdua1_company_lan.Port2-Server2PS1.usageinA 0.6 1414709192
PDU.pdua1_company_lan.Port2-Server2PS1.usageinW 106 1414709192
PDU.pdua1_company_lan.Port3-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port3-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port4-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port4-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port5-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port5-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port6-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port6-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port7-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port7-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port8-BladeChassis-1PS3.usageinA 1.4 1414709192
PDU.pdua1_company_lan.Port8-BladeChassis-1PS3.usageinW 283 1414709192
PDU.pdua1_company_lan.Port9-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port9-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port10-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port10-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port11-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port11-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port12-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port12-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port13-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port13-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port14-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port14-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port15-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port15-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port16-BladeChassis-1PS2.usageinA 1.4 1414709192
PDU.pdua1_company_lan.Port16-BladeChassis-1PS2.usageinW 284 1414709192
PDU.pdua1_company_lan.Port17-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port17-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port18-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port18-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port19-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port19-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port20-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port20-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port21-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port21-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port22-EMPTY.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port22-EMPTY.usageinW 0 1414709192
PDU.pdua1_company_lan.Port23-CiscoSwitch-A.usageinA 0.0 1414709192
PDU.pdua1_company_lan.Port23-CiscoSwitch-A.usageinW 45 1414709192
PDU.pdua1_company_lan.Port24-BladeChassis-1PS1.usageinA 1.4 1414709192
PDU.pdua1_company_lan.Port24-BladeChassis-1PS1.usageinW 288 1414709192
```

## License

The MIT License (MIT)

Copyright (c) 2014 Tren Blackburn
