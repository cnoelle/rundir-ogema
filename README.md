# rundir-ogema

## Configuration

### Homematic

OGEMA comes with a HomeMatic driver that supports both HomeMaticRF and HomeMaticIP (and possibly HomeMatic Wired). It requires either a CCU or one of the available alternative HomeMatic controllers plus appropriate software, such as [piVCCU](https://github.com/alexreinert/piVCCU), [occu](https://github.com/eq-3/occu), [RaspberryMatic](https://github.com/jens-maus/RaspberryMatic), [YAHM](https://github.com/leonsio/YAHM), etc. See https://github.com/ogema/ogema/wiki/HomeMaticXmlRpc for supported hardware and software. 

In order to activate the OGEMA HomeMatic driver you need to create a specific configuration. There is a template file in the folder *init*, which represents a basic HomeMatic RF configuration. You may need to adapt certain settings in there, for instance uncomment the *ccuUser* and *ccuPw* fields and enter your CCU credentials there, or change the port from 2001 to 2010 for HomeMaticIP instead of HomeMaticRF.

When your configuration file is complete, login to the OGEMA user interface in the browser, go to the OGEMA REST debugger interface at https://localhost:8443/org/ogema/ref-impl/rest/rest-gui/index.html (adapt scheme, host and port to your setting) and upload the adapted *HomeMatic.xml* file via the *Import resources from file* button.

If everything works fine, the HomeMatic debugging app should start to run shortly afterwards, it is available at https://localhost:8443/ogemadrivers/homematicxmlrpc/config/index.html.

#### Troubleshooting
* Make sure the CCU software is up and running and successfully connected to your controller. For piVCCU check the status on the command line via
  ``` 
  systemctl status pivccu
  ```
  (Status should be *active*). For the piVCCU setup on a Raspberry Pi see https://github.com/alexreinert/piVCCU/blob/master/docs/setup/raspberrypi.md. Further useful piVCCU commands:
  
    * change adapter settings:
    ```
    sudo dpkg-reconfigure pivccu3
    ```
  
    * attach to the piVCCU LXC container (type `exit` to detach again)
    ```
    sudo pivccu-attach	
    ```
  
* See https://github.com/ogema/ogema/wiki/HomeMaticXmlRpc
* See https://github.com/ogema/ogema/wiki/Homematic_XML-RPC_debugging



