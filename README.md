# hassio : Configuration and Automation files for HassIO Islamic Prayer

Below are the instructions to download **configuration.yaml** and **automation.yaml** files on a Windows computer


## Steps

1. Make a folder with name **rawFolder** on your desktop
2. Download a script **[hassFiles.ps1](https://raw.githubusercontent.com/msanaullahsahar/hassio/master/hassFiles.ps1)** and put it in the rawFolder,
2. Run windows Powershell as Administrator.
3. Change the directory of powershell to **rawFolder** you just created by using the command below.

```
cd C:\Users\$env:UserName\Desktop\rawFolder
```

4. Type the following command in powershell window, reply with **Y** and Hit ENTER Key.

```
set-executionpolicy remotesigned
```
5. Type the following command in powershell window and Hit Enter Key.

```
.\hassFiles.ps1
```
   
6. Wait for the process to complete.
7. Super easy. Isn't it?
8. Report any error if you encounter while using this script at here: [Report Issue](https://github.com/msanaullahsahar/hassio/issues/new)
