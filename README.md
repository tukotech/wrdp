# wrdp
Wicked RDP Manager

### FAQ
Q: I am getting "The connection cannot proceed because authentication is not enabled and the remote computer requires that authentication be enabled to connect." when connecting to a server  
A: Change policy "Require use of specific security layer for remote (RDP) connections" to use RDP or option 0. Open gpedit.msc, then do Local Computer Policy | Computer Configuration | Administrative Templates | Windows Components | Remote Desktop Services | Remote Desktop Session Host | Security | Require use of specific security layer for remote (RDP) connections = Enabled (Security Layer: RDP)  

### FAQ - Development
Q: Field FormDetached.Rdp does not have a corresponding component. Remove the declaration?  
A: Install wrdp\components\RdpControl (load RdpControlGroup.groupproj and install)