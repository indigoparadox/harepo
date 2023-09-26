# Home Assistant Add-on: SNMP server

## Installation

From the supervisor add-on store, add the following repository:

https://github.com/indigoparadox/harepo

Then, in the new list of add-ons, install `SNMP Server`

## How to use

1. Set the `community` option, eg, `public`.  Fill in the other options.
2. Set the port under network, eg, `161`.
3. Save the add-on configuration by clicking the "SAVE" button.
4. Start the add-on.

## Configuration

The SNMP server add-on can be changed to your likings. This section
describes each of the add-on configuration options.

Example add-on configuration:

```yaml
community: public
location: Home
name: RPi
email: rpi@me.com
```

### Option: `community`

The community your SNMP monitor is looking for, eg `public`

### Option `location`

The SNMP location, eg `Home`

### Option `name`

The SNMP contact name, eg `RPi`

### Email `email`

The SNMP contact email address, eg `rpi@me.com`

### Config

These are additional statements to add to the config file. Most useful will likely be the `pass` and `pass_persist` statements.

As a simple example, `pass_persist .1.3.6.1.2.1.25.1.8 /bin/sh /config/snmp_cpu_temp.sh` will start up a copy of the script /config/snmp_cpu_temp.sh when the addon is launched and forward requests for the OID .1.3.6.1.2.1.25.1.8 to that script to be answered.

Additional script includes to help in creating these custom handlers are included and outlined below.

## Custom OID Handler Functions

These can be accessed from a customer handler script by sourcing `/snmp_test.sh` from within that script.

### snmp\_trim\_oid

Usage: `snmp_trim_oid "$SNMP\_OID" "$INPUT_OID"`

Trim off `$SNMP_OID` from the `$INPUT_OID` passed to the script. The result is placed in the variable `$OID_END`, which can be passed to the `snmp_test` handler.

### snmp\_proc\_once

Usage: `snmp_proc_once $@`

Test to see if `$1` is `-g` or `-n`. If it is, then run the `snmp_test` handler on the `$OID_END` variable resulting from trimming `$SNMP_OID` from `$2` (if `-g` is specified), or its next neighbor (if `-n` is specified).

If `-g` or `-n` were specified with a valid OID, then set `SNMP_PROC_ONCE` to 1 to indicate that the script should quit afterwards.

### snmp\_proc\_persist

Usage: `snmp_proc_persist`

Starts up the persistant handler, which continually takes get/getnext requests and OIDs from snmpd and runs the `snmp_test` handler on the `$OID_END` variable resulting from trimming `$SNMP_OID` from the passed OID until it is forcibly quit.

## Custom OID Handler Example

The following example sets `$SNMP_OID` to the OID for a block device's name and creates an `snmp_test` handler which responds to requests for `OID.index` with the name of the device at `index` in the `iostat` command output:

```bash
#!/bin/bash

SNMP_OID=.1.3.6.1.4.1.2021.13.15.1.1.2
snmp_test() {
   IOSTAT_DEV_CT="`iostat | grep -v "^\($\|avg\|Linux\|\s\|Device\)" | wc -l`"

   if [ $2 -lt $IOSTAT_DEV_CT ]; then
      echo $1.$2
      echo string
   else
      echo NONE
   fi
}

source /snmp_test.sh

snmp_proc_once $@
if [ $SNMP_PROC_ONCE -eq 1 ]; then
        exit
else
        snmp_proc_persist
fi
```

## Support

In case you've found a bug, please [open an issue on GitHub][issue].

[issue]: https://github.com/indigoparadox/harepo/issues
[repository]: https://github.com/indigoparadox/harepo/
