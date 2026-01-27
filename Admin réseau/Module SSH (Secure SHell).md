1. Console port sécurité Login /CLI
- Par défaut, pas besoin de mot de passe pour accéder au CLI Cisco via port console
- Peut mettre une mot de passe / console line /CLI via console
- Console line /toujours 0 (car unseul console line)
**Logine sans username**
```
line console 0
password ccna
login
end
exit
```
**Login avec username**
```
Router>en

Router#conf t

Router(config)#username sylvain secret ccnp

Router(config)#line console 0

Router(config-line)#login local

Router(config-line)#end

Router#exit
```
- Sans activité pendant 3mn et 30 séc, l'utilisateur ejecté
```
Router>en

Router#conf t

Router(config)#line con 0

Router(config-line)#exec-timeout 1 30

Router(config-line)#password ccna

Router(config-line)#logging synchronous

Router(config-line)#login local

Router(config-line)#exit

Router(config)#end

Router#exit
```

# Telnet

**Configuration de SVI gerable à distance:**
```
Switch>en

Switch#conf t

Switch(config)#enable secret lmscode

Switch(config)#username lms secret lmescode

Switch(config)#access-list 1 permit host 192.168.2.1

Switch(config)#line vty 0 15

Switch(config-line)#login local

Switch(config-line)#exec-timeout 1 30

Switch(config-line)#transport input telnet

Switch(config-line)#access-class 1 in

Switch(config-line)#
```

